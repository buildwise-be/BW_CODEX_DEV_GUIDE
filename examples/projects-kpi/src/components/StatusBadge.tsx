import type { ProjectStatus } from "../types";

export function StatusBadge({ status }: { status: ProjectStatus }) {
  const className = status === "En bonne voie" ? "status-good" : status === "À surveiller" ? "status-watch" : "status-late";
  return <span className={`status-badge ${className}`}><span className="status-dot" />{status}</span>;
}
