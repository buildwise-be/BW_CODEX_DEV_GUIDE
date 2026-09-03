import { BarChart3, Bell, ChevronDown, CircleHelp, LayoutDashboard, Menu, PanelLeft, Plus, Search, Settings, Sparkles, Target, X } from "lucide-react";
import { useState } from "react";
import { kpis } from "./data/kpis";
import { projects } from "./data/projects";
import type { Kpi } from "./types";
import { MetricCard } from "./components/MetricCard";
import { ProjectTable } from "./components/ProjectTable";

type Page = "overview" | "projects" | "kpis";

function App() {
  const [page, setPage] = useState<Page>("overview");
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [showToast, setShowToast] = useState(false);

  const showComingSoon = () => { setShowToast(true); window.setTimeout(() => setShowToast(false), 3200); };
  const pageTitle = page === "projects" ? "Suivi des projets" : page === "kpis" ? "Dashboard KPI" : "Bonjour, Thomas";
  const pageIntro = page === "projects" ? "Gardez une vue claire sur les projets qui nécessitent votre attention." : page === "kpis" ? "Les indicateurs qui vous aident à prendre les bonnes décisions." : "Voici ce qui mérite votre attention aujourd’hui.";

  return <div className="app-shell">
    <aside className={`sidebar ${sidebarOpen ? "is-open" : ""}`}><div className="brand"><span className="brand-mark">b</span><span>buildwise</span><button className="mobile-close" onClick={() => setSidebarOpen(false)} aria-label="Fermer le menu"><X size={20} /></button></div><div className="workspace-switcher"><span className="workspace-icon">B</span><span><small>ESPACE DE TRAVAIL</small><strong>Buildwise Demo</strong></span><ChevronDown size={15} /></div><nav><button className={page === "overview" ? "nav-item active" : "nav-item"} onClick={() => { setPage("overview"); setSidebarOpen(false); }}><LayoutDashboard size={18} />Vue d’ensemble</button><button className={page === "projects" ? "nav-item active" : "nav-item"} onClick={() => { setPage("projects"); setSidebarOpen(false); }}><Target size={18} />Projets<span className="nav-count">24</span></button><button className={page === "kpis" ? "nav-item active" : "nav-item"} onClick={() => { setPage("kpis"); setSidebarOpen(false); }}><BarChart3 size={18} />Indicateurs</button></nav><div className="sidebar-bottom"><button className="nav-item" onClick={showComingSoon}><Settings size={18} />Paramètres</button><button className="nav-item" onClick={showComingSoon}><CircleHelp size={18} />Besoin d’aide ?</button><div className="user-card"><span className="avatar avatar-user">TL</span><span><strong>Thomas Laurent</strong><small>Administrateur</small></span><ChevronDown size={15} /></div></div></aside>
    <main className="main-content"><header className="topbar"><button className="mobile-menu" onClick={() => setSidebarOpen(true)} aria-label="Ouvrir le menu"><Menu size={21} /></button><div className="breadcrumbs"><span>Buildwise Demo</span><span>/</span><strong>{page === "overview" ? "Vue d’ensemble" : page === "projects" ? "Projets" : "Indicateurs"}</strong></div><div className="topbar-actions"><button className="icon-button" onClick={showComingSoon} aria-label="Rechercher"><Search size={19} /></button><button className="icon-button notification" onClick={showComingSoon} aria-label="Notifications"><Bell size={19} /><span /></button><span className="topbar-avatar">TL</span></div></header>
      <div className="content"><div className="page-heading"><div><p className="eyebrow">{page === "overview" ? "Mardi 3 septembre 2026" : "Pilotage opérationnel"}</p><h1>{pageTitle}</h1><p className="page-intro">{pageIntro}</p></div><button className="primary-button" onClick={showComingSoon}><Plus size={17} />Nouveau projet</button></div>
        {page === "overview" && <Overview onNavigate={setPage} onAction={showComingSoon} />}
        {page === "projects" && <ProjectTable projects={projects} />}
        {page === "kpis" && <KpiPage kpis={kpis} onAction={showComingSoon} />}
      </div>
    </main>
    {showToast && <div className="toast"><Sparkles size={17} /><span>Cette action est prête à être connectée à votre processus métier.</span><button onClick={() => setShowToast(false)} aria-label="Fermer"><X size={15} /></button></div>}
  </div>;
}

function Overview({ onNavigate, onAction }: { onNavigate: (page: Page) => void; onAction: () => void }) {
  return <><div className="metric-grid">{kpis.map((kpi) => <MetricCard key={kpi.label} kpi={kpi} />)}</div><div className="insight-banner"><div className="insight-icon"><Sparkles size={20} /></div><div><strong>À retenir</strong><p>La plupart des projets avancent comme prévu. 3 projets ont toutefois besoin d’une décision cette semaine.</p></div><button className="secondary-button" onClick={onNavigate.bind(null, "projects")}>Voir les projets</button></div><ProjectTable projects={projects.slice(0, 3)} /><div className="quick-actions"><div><p className="eyebrow">Pour commencer</p><h2>Que souhaitez-vous faire ?</h2></div><div className="quick-action-grid"><button onClick={onAction}><span className="quick-icon teal"><Plus size={19} /></span><span><strong>Ajouter un projet</strong><small>Créer un nouveau suivi</small></span></button><button onClick={onNavigate.bind(null, "kpis")}><span className="quick-icon purple"><BarChart3 size={19} /></span><span><strong>Lire les indicateurs</strong><small>Comprendre la performance</small></span></button><button onClick={onAction}><span className="quick-icon orange"><PanelLeft size={19} /></span><span><strong>Préparer un point</strong><small>Rassembler les éléments clés</small></span></button></div></div></>;
}

function KpiPage({ kpis: items, onAction }: { kpis: Kpi[]; onAction: () => void }) { return <><div className="metric-grid">{items.map((kpi) => <MetricCard key={kpi.label} kpi={kpi} />)}</div><section className="panel"><div className="panel-heading"><div><p className="eyebrow">Lecture business</p><h2>Ce qu’il faut retenir</h2></div><button className="secondary-button" onClick={onAction}>Exporter le point</button></div><div className="insight-list"><div><span className="insight-number">01</span><p><strong>La capacité progresse.</strong> Le nombre de projets actifs augmente sans dégrader le respect des délais.</p></div><div><span className="insight-number">02</span><p><strong>Les arbitrages sont le point d’attention.</strong> Sept décisions sont actuellement bloquantes ou proches de l’être.</p></div><div><span className="insight-number">03</span><p><strong>Une action simple est possible.</strong> Un point de coordination cette semaine devrait réduire le délai moyen.</p></div></div></section></>; }

export default App;
