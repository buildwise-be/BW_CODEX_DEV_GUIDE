import { createHash } from 'node:crypto';
import { existsSync, readFileSync, readdirSync } from 'node:fs';
import { resolve, relative, join } from 'node:path';
import { fileURLToPath } from 'node:url';

export const fingerprint = (text) => createHash('sha256').update(text.replace(/\r\n/g, '\n')).digest('hex');

/** Conservative static guard. It does not replace a browser/contrast review. */
export function checkBrand(root, { frameworkOnly = false } = {}) {
  const errors = [];
  const read = (path) => {
    const full = resolve(root, path);
    if (!existsSync(full)) { errors.push(`Ressource absente : ${path}`); return null; }
    return readFileSync(full, 'utf8');
  };
  const rawPolicy = read('assets/brand/policy.json');
  if (!rawPolicy) return errors;
  let policy;
  try { policy = JSON.parse(rawPolicy); } catch { return ['Politique graphique JSON invalide.']; }
  if (!Array.isArray(policy.resources) || policy.resources.length !== 2) return ['Politique graphique incomplète.'];
  for (const resource of policy.resources) {
    const canonical = read(resource.source);
    if (canonical !== null && fingerprint(canonical) !== resource.sha256) errors.push(`Référence modifiée sans validation : ${resource.source}`);
    if (!frameworkOnly) {
      const generated = read(resource.target);
      if (generated !== null && fingerprint(generated) !== resource.sha256) errors.push(`Charte modifiée : ${resource.target}`);
    }
  }
  if (frameworkOnly) return errors;
  const index = read('index.html');
  if (index !== null && !/<meta\s+name="theme-color"\s+content="#0087b7"\s*\/?\s*>/i.test(index)) errors.push('La couleur du navigateur doit être le bleu Buildwise #0087b7.');
  if (index !== null && /fonts\.(?:googleapis|gstatic)\.com|use\.typekit\.net|<style\b|\sstyle\s*=/i.test(index)) errors.push('Style ou police hors thème dans index.html.');
  const styles = read('src/styles.css');
  if (styles !== null && !/@import\s+["']\.\/brand\.css["']/.test(styles)) errors.push('Importer ./brand.css dans src/styles.css.');
  const main = read('src/main.tsx');
  if (main !== null && !/import\s+["']\.\/styles\.css["']/.test(main)) errors.push('Le point d’entrée doit importer ./styles.css.');
  const sourceFiles = [];
  const walk = (dir) => {
    if (!existsSync(dir)) return;
    for (const entry of readdirSync(dir, { withFileTypes: true })) {
      const path = join(dir, entry.name);
      if (entry.isSymbolicLink()) { errors.push(`Lien symbolique non inspecté : ${relative(root, path)}`); continue; }
      if (entry.isDirectory()) walk(path);
      else if (/\.(css|scss|tsx?|jsx?|svg)$/.test(path) && !/\.(test|spec)\.[tj]sx?$/.test(path)) sourceFiles.push(path);
    }
  };
  walk(resolve(root, 'src'));
  let logoUsed = false;
  for (const path of sourceFiles) {
    const name = relative(root, path).replaceAll('\\', '/');
    const text = readFileSync(path, 'utf8');
    if (text.includes('brand/buildwise-logo.svg')) logoUsed = true;
    if (name === 'src/brand.css') continue;
    // Only comments are removed. Dynamic styles and runtime libraries still need review.
    const code = text.replace(/\/\*[\s\S]*?\*\//g, '');
    const rules = [
      [/#(?:[\da-f]{8}|[\da-f]{6}|[\da-f]{4}|[\da-f]{3})\b|\b(?:rgba?|hsla?|oklch|oklab|color-mix)\s*\(/i, 'couleur locale : utiliser un token --bw-*'],
      [/--bw-[\w-]+\s*:/, 'redéfinition du thème central'],
      [/\.bw-(?:logo|header|button|panel)\b[^{}]*\{/, 'surcharge du composant de marque : modifier uniquement le thème après accord'],
      [/font-family\s*:|fontFamily\s*:|@font-face|fonts\.(?:googleapis|gstatic)\.com|use\.typekit\.net/i, 'police alternative ou distante'],
      [/\b(?:bg|text|border|ring|fill|stroke|from|via|to)-(?:slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)-\d{2,3}\b|\b(?:bg|text|border)-(?:black|white)\b/, 'palette Tailwind alternative'],
      [/(?:background(?:-color)?|color|fill|stroke)\s*:\s*["']?(?!var\b|currentColor\b|inherit\b|transparent\b|none\b|initial\b|unset\b)[a-z]+\b/i, 'couleur nommée ou expression à vérifier'],
    ];
    for (const [pattern, message] of rules) if (pattern.test(code)) errors.push(`${name} : ${message}`);
  }
  if (!logoUsed) errors.push('Le logo Buildwise fourni doit être référencé dans src/.');
  return errors;
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const errors = checkBrand(resolve(fileURLToPath(new URL('..', import.meta.url))), { frameworkOnly: process.argv.includes('--framework') });
  if (errors.length) { console.error(errors.join('\n')); process.exitCode = 1; }
  else console.log('Contrôle graphique statique réussi. Revue visuelle encore requise.');
}
