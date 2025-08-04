import {
  Entity,
  Column,
  ManyToOne,
  OneToMany,
  Index,
  JoinColumn,
} from 'typeorm';
import { Project } from './project.entity';
import { Checklist } from './checklist.entity';
import Model from './base.entity';

@Entity('phases')
@Index(['id', 'name'])
export class Phase extends Model {
  @Column()
  title: string;

  @Column()
  name: string;

  @Column({ default: 'in-progress' })
  status: string;

  @Column({ name: 'project_id', nullable: true })
  projectId: number;

  @ManyToOne(() => Project, (project) => project.phases, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'project_id' })
  project: Project;

  @OneToMany(() => Checklist, (checklist) => checklist.phase, {
    cascade: true,
  })
  checklists: Checklist[];
}
