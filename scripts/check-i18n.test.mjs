import { test } from "node:test";
import assert from "node:assert/strict";
import { cpSync, mkdtempSync, mkdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { fileURLToPath } from "node:url";
import { checkI18n } from "./check-i18n.mjs";

const repo = fileURLToPath(new URL("..", import.meta.url));
function fixture(t) {
  const root = mkdtempSync(join(tmpdir(), "bw-i18n-"));
  t.after(() => rmSync(root, { recursive: true, force: true }));
  mkdirSync(join(root, "src"), { recursive: true });
  cpSync(join(repo, "templates/application/src"), join(root, "src"), { recursive: true });
  return root;
}
test("le socle est bilingue", (t) => assert.deepEqual(checkI18n(fixture(t)), []));
test("refuse une clé néerlandaise manquante", (t) => {
  const root = fixture(t); const path = join(root, "src/i18n/messages/nl.json");
  const catalog = JSON.parse(readFileSync(path, "utf8")); delete catalog["app.ready.body"];
  writeFileSync(path, JSON.stringify(catalog)); assert.ok(checkI18n(root).some((error) => error.includes("Clé NL manquante")));
});
test("refuse une traduction vide", (t) => {
  const root = fixture(t); const path = join(root, "src/i18n/messages/fr.json");
  const catalog = JSON.parse(readFileSync(path, "utf8")); catalog["app.title"] = "";
  writeFileSync(path, JSON.stringify(catalog)); assert.ok(checkI18n(root).some((error) => error.includes("Traduction vide")));
});
test("refuse du texte JSX en dur", (t) => {
  const root = fixture(t); writeFileSync(join(root, "src/Hardcoded.tsx"), "export const A=()=> <p>Texte oublié</p>;");
  assert.ok(checkI18n(root).some((error) => error.includes("texte JSX en dur")));
});
test("refuse un attribut accessible en dur", (t) => {
  const root = fixture(t); writeFileSync(join(root, "src/Hardcoded.tsx"), "export const A=()=> <button aria-label=\"Fermer\"/>;");
  assert.ok(checkI18n(root).some((error) => error.includes("attribut traduisible")));
});
