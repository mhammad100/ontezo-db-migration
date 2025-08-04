import {
  Entity,
  Column,
  ManyToOne,
  JoinColumn,
  Index,
  OneToMany,
} from 'typeorm';
import Model from './base.entity';
import { Project } from './project.entity';
import { Task } from './task.entity';

@Entity('project_statuses')
@Index(['id', 'name', 'projectId'])
export class ProjectStatus extends Model {
  @Column()
  display_name: string;

  @Column()
  name: string;

  @Column()
  order: number;

  @Column({ name: 'project_id' })
  projectId: number;

  @ManyToOne(() => Project, (project) => project.statuses, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'project_id' })
  project: Project;

  @OneToMany(() => Task, (task) => task.status, { cascade: true })
  tasks: Task[];
}
