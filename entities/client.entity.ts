import {
  Entity,
  Column,
  OneToMany,
  Index,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import Model from './base.entity';
import { Project } from './project.entity';
import { User } from './user.entity';

@Entity('clients')
@Index(['id', 'name'])
export class Client extends Model {
  @Column()
  name: string;

  @Column({ nullable: true })
  designation: string;

  @Column({ nullable: true })
  phone: string;

  @Column({ nullable: true })
  email: string;

  @Column({ name: 'company_name', nullable: true })
  companyName: string;

  @Column({ name: 'company_phone', nullable: true })
  companyPhone: string;

  @Column({ name: 'company_email', nullable: true })
  companyEmail: string;

  @Column({ name: 'created_by_id', nullable: true })
  createdById?: number;

  // created by relationship
  @ManyToOne(() => User)
  @JoinColumn({ name: 'created_by_id' })
  createdBy: User;

  @OneToMany(() => Project, (project) => project.client, {
    cascade: true,
  })
  projects: Project[];
}
