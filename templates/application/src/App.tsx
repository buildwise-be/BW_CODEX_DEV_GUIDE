import { useEffect, useState } from "react";
import { initialLanguage, setDocumentLanguage, t, type Language } from "./i18n";

export default function App() {
  const [language, setLanguage] = useState<Language>(initialLanguage);
  useEffect(() => setDocumentLanguage(language), [language]);

  return (
    <>
      <header className="bw-header">
        <img className="bw-logo" src={`${import.meta.env.BASE_URL}brand/buildwise-logo.svg`} alt="Buildwise" />
        <span>{t("app.status", language)}</span>
        <nav className="bw-language" aria-label={t("language.label", language)}>
          {(["fr", "nl"] as const).map((code) => (
            <button key={code} className="bw-language__button" type="button"
              aria-pressed={language === code} onClick={() => setLanguage(code)}
              title={t(`language.${code}`, language)}>{code.toUpperCase()}</button>
          ))}
        </nav>
      </header>
      <main className="bw-shell">
        <section className="bw-panel">
          <h1>{t("app.ready.title", language)}</h1>
          <p>{t("app.ready.body", language)}</p>
        </section>
      </main>
    </>
  );
}
