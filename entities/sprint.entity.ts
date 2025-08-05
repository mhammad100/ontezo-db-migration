import { Entity, Column, ManyToOne, OneToMany, JoinColumn } from 'typeorm';
import Model from './base.entity';
import { Project } from './project.entity';
import { Task } from './task.entity';
import { SprintStatus } from './sprint-status.entity';
import { SprintStatuses } from '../common/enums/sprints.enum';

@Entity('sprints')
export class Sprint extends Model {
  @Column()
  name: string;

  @Column({ nullable: true })
  description: string;

  @Column({ name: 'start_date', type: 'date', nullable: true })
  startDate: Date;

  @Column({ name: 'end_date', type: 'date', nullable: true })
  endDate: Date;

  @Column({ nullable: true })
  duration: string;

  @Column({ name: 'old_id', nullable: true })
  oldId: string;

  @Column({
    type: 'enum',
    enum: SprintStatuses,
    default: SprintStatuses.PLANNED,
  })
  status: SprintStatuses;

  @Column({ name: 'project_id' })
  projectId: number;

  @OneToMany(() => SprintStatus, (status) => status.sprint, {
    cascade: true,
  })
  statuses: SprintStatus[];

  @ManyToOne(() => Project, (project) => project.sprints, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'project_id' })
  project: Project;

  @OneToMany(() => Task, (task) => task.sprint, {
    cascade: true,
  })
  tasks: Task[];
}
