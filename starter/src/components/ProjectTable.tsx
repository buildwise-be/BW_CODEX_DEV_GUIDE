import { ArrowUpRight, CalendarDays, Search } from "lucide-react";
import { useMemo, useState } from "react";
import type { Project, ProjectStatus } from "../types";
import { StatusBadge } from "./StatusBadge";

export function ProjectTable({ projects }: { projects: Project[] }) {
  const [query, setQuery] = useState("");
  const [status, setStatus] = useState<"Tous" | ProjectStatus>("Tous");
  const filteredProjects = useMemo(() => projects.filter((project) => {
    const matchesQuery = `${project.name} ${project.owner}`.toLowerCase().includes(query.toLowerCase());
    return matchesQuery && (status === "Tous" || project.status === status);
  }), [projects, query, status]);

  return (
    <section className="panel project-panel">
      <div className="panel-heading"><div><p className="eyebrow">Vue opérationnelle</p><h2>Projets à suivre</h2></div><button className="text-button">Voir tous les projets <ArrowUpRight size={16} /></button></div>
      <div className="table-toolbar"><label className="search-field"><Search size={17} /><input value={query} onChange={(event) => setQuery(event.target.value)} placeholder="Rechercher un projet ou un responsable" /></label><select value={status} onChange={(event) => setStatus(event.target.value as "Tous" | ProjectStatus)}><option>Tous</option><option>En bonne voie</option><option>À surveiller</option><option>En retard</option></select></div>
      {filteredProjects.length === 0 ? <div className="empty-state"><Search size={22} /><strong>Aucun projet trouvé</strong><span>Essayez un autre mot-clé ou filtre.</span></div> : <div className="table-wrap"><table><thead><tr><th>Projet</th><th>Responsable</th><th>État</th><th>Échéance</th><th>Avancement</th></tr></thead><tbody>{filteredProjects.map((project) => <tr key={project.id}><td><strong>{project.name}</strong><span className="cell-description">{project.description}</span></td><td><span className="person"><span className="avatar">{project.initials}</span>{project.owner}</span></td><td><StatusBadge status={project.status} /></td><td><span className="date"><CalendarDays size={15} />{project.dueDate}</span></td><td><div className="progress-label"><span>{project.progress}%</span><span className="muted">{project.nextAction}</span></div><div className="progress-track"><span style={{ width: `${project.progress}%` }} /></div></td></tr>)}</tbody></table></div>}
    </section>
  );
}
