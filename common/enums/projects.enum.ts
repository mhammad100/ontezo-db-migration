export enum ProjectDuration {
  SHORT_TERM = 'short-term',
  MID_TERM = 'mid-term',
  LONG_TERM = 'long-term',
  ON_GOING = 'on-going',
}

export type IProjectStatus = {
  display_name: string;
  name: 'backlog' | 'todo' | 'in_progress' | 'review' | 'done';
  order: number;
};

export const DEFAULT_PROJECT_STATUSES: IProjectStatus[] = [
  {
    display_name: 'Backlog',
    name: 'backlog',
    order: 1,
  },
  {
    display_name: 'To Do',
    name: 'todo',
    order: 2,
  },
  {
    display_name: 'In Progress',
    name: 'in_progress',
    order: 3,
  },
  {
    display_name: 'In Review',
    name: 'review',
    order: 4,
  },
  {
    display_name: 'Done',
    name: 'done',
    order: 5,
  },
];

export const DEFAULT_PROJECT_PHASES = [
  {
    title: 'Planning',
    name: 'planning',
    status: 'in-progress',
    checklists: [
      {
        name: 'Requirements Gathering',
        status: 'active',
        items: [
          {
            description: 'Gather functional requirements',
            isChecked: false,
          },
          { description: 'Identify stakeholders', isChecked: false },
          { description: 'Define project scope', isChecked: false },
        ],
      },
    ],
  },
  {
    title: 'Design & Prototyping',
    name: 'design_prototyping',
    status: 'not-started',
    checklists: [
      {
        name: 'Design Process',
        status: 'active',
        items: [
          { description: 'Create wireframes', isChecked: false },
          { description: 'Develop prototypes', isChecked: false },
          { description: 'Review with stakeholders', isChecked: false },
        ],
      },
    ],
  },
  {
    title: 'Development',
    name: 'development',
    status: 'not-started',
    checklists: [
      {
        name: 'Setup',
        status: 'active',
        items: [
          {
            description: 'Set up development environment',
            isChecked: false,
          },
          {
            description: 'Initialize project repository',
            isChecked: false,
          },
        ],
      },
      {
        name: 'Implementation',
        status: 'active',
        items: [
          { description: 'Implement core features', isChecked: false },
          { description: 'Code review', isChecked: false },
        ],
      },
    ],
  },
  {
    title: 'Testing & Deployment',
    name: 'testing_deployment',
    status: 'not-started',
    checklists: [
      {
        name: 'Quality Assurance',
        status: 'active',
        items: [
          { description: 'Create test plan', isChecked: false },
          { description: 'Execute test cases', isChecked: false },
          { description: 'Bug fixing', isChecked: false },
          { description: 'Deploy to production', isChecked: false },
        ],
      },
    ],
  },
  {
    title: 'Maintenance & Support',
    name: 'maintenance_support',
    status: 'not-started',
    checklists: [
      {
        name: 'Post-Launch Activities',
        status: 'active',
        items: [
          { description: 'Monitor performance', isChecked: false },
          { description: 'Address user feedback', isChecked: false },
          { description: 'Implement updates', isChecked: false },
        ],
      },
    ],
  },
];
