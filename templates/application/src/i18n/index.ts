import fr from "./messages/fr.json";
import nl from "./messages/nl.json";

export const supportedLanguages = ["fr", "nl"] as const;
export type Language = (typeof supportedLanguages)[number];
export type TranslationKey = keyof typeof fr;

const catalogs: Record<Language, Record<TranslationKey, string>> = { fr, nl };
export const isLanguage = (value: unknown): value is Language =>
  typeof value === "string" && supportedLanguages.includes(value as Language);

export function initialLanguage(): Language {
  if (typeof window === "undefined") return "fr";
  let saved: string | null = null;
  try { saved = window.localStorage.getItem("bw-language"); } catch { /* Storage can be disabled. */ }
  if (isLanguage(saved)) return saved;
  const preferences = window.navigator.languages?.length ? window.navigator.languages : [window.navigator.language];
  return preferences.some((language) => language?.toLowerCase().startsWith("nl")) ? "nl" : "fr";
}

export function t(key: TranslationKey, language: Language): string {
  return catalogs[language][key] ?? catalogs.fr[key];
}

export function setDocumentLanguage(language: Language): void {
  if (typeof document === "undefined") return;
  document.documentElement.lang = language;
  document.title = t("app.title", language);
  try { window.localStorage.setItem("bw-language", language); } catch { /* Language still changes for this session. */ }
}
