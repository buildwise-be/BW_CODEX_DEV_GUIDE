import { test } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, mkdirSync, readFileSync, writeFileSync, cpSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { checkBrand } from './check-brand.mjs';

const repo = fileURLToPath(new URL('..', import.meta.url));
const theme = readFileSync(join(repo, 'assets/brand/theme.css'), 'utf8');
const token = (name) => theme.match(new RegExp(`--bw-${name}:\\s*([^;]+);`))?.[1].trim();

test('les valeurs structurantes respectent la spécification UI', () => {
  for (const [name, value] of Object.entries({
    blue: '#0087b7', turquoise: '#00bfb6',
    font: '"Roboto", Arial, Helvetica, sans-serif',
    'radius-pill': '999px', 'radius-panel': '16px', 'radius-control': '8px',
    'control-height': '48px', 'control-compact': '40px',
    'text-md': '1rem', 'text-sm': '0.875rem', 'space-6': '24px',
  })) assert.equal(token(name), value, name);
  assert.ok(theme.includes('prefers-reduced-motion: reduce'));
});

function luminance(hex) {
  const rgb = hex.replace('#', '').match(/../g).map(h => parseInt(h, 16) / 255)
    .map(v => v <= 0.04045 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4);
  return rgb[0] * 0.2126 + rgb[1] * 0.7152 + rgb[2] * 0.0722;
}
test('les paires de texte prévues atteignent un contraste de 4.5:1', () => {
  for (const [foreground, background] of [
    ['text', 'surface'], ['text', 'background'], ['muted', 'surface'],
    ['surface', 'action'], ['surface', 'action-hover'],
    ['surface', 'danger'], ['surface', 'danger-hover'],
    ['success', 'success-bg'], ['warning', 'warning-bg'], ['danger', 'danger-bg'],
    ['action', 'info-bg'], ['disabled-text', 'disabled-bg'],
  ]) {
    const pair = [luminance(token(foreground)), luminance(token(background))].sort((a,b) => b-a);
    assert.ok((pair[0] + 0.05) / (pair[1] + 0.05) >= 4.5, `${foreground}/${background}`);
  }
});
function fixture(t) {
  const root = mkdtempSync(join(tmpdir(), 'bw-brand-'));
  // Only the directory returned by mkdtempSync is removed.
  t.after(() => rmSync(root, { recursive: true, force: true }));
  mkdirSync(join(root, 'assets'), { recursive: true });
  cpSync(join(repo, 'assets/brand'), join(root, 'assets/brand'), { recursive: true });
  cpSync(join(repo, 'templates/application/src'), join(root, 'src'), { recursive: true });
  cpSync(join(repo, 'templates/application/index.html'), join(root, 'index.html'));
  mkdirSync(join(root, 'public/brand'), { recursive: true });
  cpSync(join(root, 'assets/brand/theme.css'), join(root, 'src/brand.css'));
  cpSync(join(root, 'assets/brand/buildwise-logo.svg'), join(root, 'public/brand/buildwise-logo.svg'));
  return root;
}
test('le socle fourni respecte le contrôle statique', t => assert.deepEqual(checkBrand(fixture(t)), []));
for (const [name, path, content] of [
  ['couleur locale', 'src/extra.css', '.card { color: #ff00aa; }'],
  ['couleur nommée', 'src/extra.css', '.card { color: red; }'],
  ['palette Tailwind', 'src/extra.tsx', 'export const c = "bg-purple-500";'],
  ['police', 'src/extra.css', '.card { font-family: Inter; }'],
  ['token redéfini', 'src/extra.css', ':root { --bw-blue: red; }'],
  ['logo modifié', 'public/brand/buildwise-logo.svg', '<svg/>'],
  ['thème modifié', 'src/brand.css', ':root {}'],
  ['référence modifiée', 'assets/brand/theme.css', ':root {}'],
  ['import retiré', 'src/styles.css', ''],
  ['entrée sans styles', 'src/main.tsx', 'export {};'],
  ['logo non référencé', 'src/App.tsx', 'export default function App() { return null; }'],
  ['surcharge du logo', 'src/extra.css', '.bw-logo { filter: grayscale(1); }'],
  ['couleur navigateur', 'index.html', '<meta name="theme-color" content="#123b3a" />'],
]) test(`refuse ${name}`, t => {
  const root = fixture(t);
  writeFileSync(join(root, path), content);
  assert.ok(checkBrand(root).length > 0);
});
test('accepte les tokens et les fins de ligne Windows', t => {
  const root = fixture(t);
  writeFileSync(join(root, 'src/extra.css'), '.card { color: var(--bw-text); background: transparent; }');
  const path = join(root, 'src/brand.css');
  writeFileSync(path, readFileSync(path, 'utf8').replace(/\r?\n/g, '\r\n'));
  assert.deepEqual(checkBrand(root), []);
});
