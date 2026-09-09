import { existsSync, readFileSync, readdirSync } from "node:fs";
import { join, relative, resolve } from "node:path";
import { fileURLToPath } from "node:url";

export function checkI18n(root) {
  const errors = [];
  const catalogPath = (language) => resolve(root, `src/i18n/messages/${language}.json`);
  const catalogs = {};
  for (const language of ["fr", "nl"]) {
    const path = catalogPath(language);
    if (!existsSync(path)) { errors.push(`Catalogue obligatoire absent : ${language}.json`); continue; }
    try { catalogs[language] = JSON.parse(readFileSync(path, "utf8")); }
    catch { errors.push(`Catalogue JSON invalide : ${language}.json`); }
  }
  if (catalogs.fr && catalogs.nl) {
    const frKeys = Object.keys(catalogs.fr).sort();
    const nlKeys = Object.keys(catalogs.nl).sort();
    for (const key of frKeys.filter((key) => !(key in catalogs.nl))) errors.push(`Clé NL manquante : ${key}`);
    for (const key of nlKeys.filter((key) => !(key in catalogs.fr))) errors.push(`Clé FR manquante : ${key}`);
    for (const language of ["fr", "nl"]) for (const [key, value] of Object.entries(catalogs[language])) {
      if (typeof value !== "string" || !value.trim()) errors.push(`Traduction vide ou invalide : ${language}.${key}`);
    }
  }
  const source = resolve(root, "src");
  const files = [];
  const walk = (dir) => {
    if (!existsSync(dir)) return;
    for (const entry of readdirSync(dir, { withFileTypes: true })) {
      const path = join(dir, entry.name);
      if (entry.isDirectory() && entry.name !== "messages") walk(path);
      else if (entry.isFile() && /\.tsx$/.test(entry.name) && !/\.(test|spec)\.tsx$/.test(entry.name)) files.push(path);
    }
  };
  walk(source);
  for (const path of files) {
    const name = relative(root, path).replaceAll("\\", "/");
    const code = readFileSync(path, "utf8").replace(/\/\*[\s\S]*?\*\//g, "");
    for (const match of code.matchAll(/<[A-Za-z][\w.]*\b[^>]*>\s*([A-Za-zÀ-ÿ][^<{]*?)\s*</g)) {
      if (!/^(Buildwise|FR|NL)$/.test(match[1].trim())) errors.push(`${name} : texte JSX en dur « ${match[1].trim()} »`);
    }
    for (const match of code.matchAll(/\b(?:aria-label|placeholder|title)\s*=\s*["']([^"']+)["']/g)) {
      if (!/^(Buildwise|FR|NL)$/.test(match[1])) errors.push(`${name} : attribut traduisible en dur « ${match[1]} »`);
    }
  }
  return errors;
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const errors = checkI18n(resolve(fileURLToPath(new URL("..", import.meta.url))));
  if (errors.length) { console.error(errors.join("\n")); process.exitCode = 1; }
  else console.log("Contrôle FR/NL réussi. Revue linguistique humaine encore requise.");
}
