export default function App() {
  return (
    <>
      <header className="bw-header">
        <img className="bw-logo" src={`${import.meta.env.BASE_URL}brand/buildwise-logo.svg`} alt="Buildwise" />
        <span>Application en construction</span>
      </header>
      <main className="bw-shell">
        <section className="bw-panel">
          <h1>Votre besoin a été cadré</h1>
          <p>Le socle est prêt. Le parcours métier reste à construire et à vérifier par Codex.</p>
        </section>
      </main>
    </>
  );
}
