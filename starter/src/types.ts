export type ProjectStatus = "En bonne voie" | "À surveiller" | "En retard";

export type Project = {
  id: string;
  name: string;
  owner: string;
  initials: string;
  status: ProjectStatus;
  dueDate: string;
  progress: number;
  description: string;
  nextAction: string;
};

export type Kpi = {
  label: string;
  value: string;
  change: string;
  direction: "up" | "down" | "flat";
  target: string;
  tone: "teal" | "orange" | "blue" | "purple";
};
