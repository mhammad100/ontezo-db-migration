import { Entity, Column, OneToMany, Index, OneToOne } from 'typeorm';
import Model from './base.entity';
import { User } from './user.entity';

@Entity({ name: 'tenants' })
@Index('tenant_name_idx', ['name'], { unique: true })
@Index('tenant_subdomain_idx', ['subdomain'], { unique: true })
export class Tenant extends Model {
  @Column({ nullable: true })
  ownerId: number;
  
  @Column({ unique: true })
  name: string;

  @Column({ nullable: true })
  email: string;

  @Column({ unique: true })
  subdomain: string;

  @Column({ name: 'database_name', nullable: true })
  databaseName: string;

  @Column({ name: 'database_host', nullable: true })
  databaseHost: string;

  @Column({ name: 'database_user', nullable: true })
  databaseUser: string;

  @Column({ name: 'database_pwd', nullable: true })
  databasePassword: string;

  @OneToMany(() => User, (user) => user.tenant, {
    cascade: true,
    onDelete: 'CASCADE',
  })
  users: User[];
  
  @OneToOne(() => User, (user) => user.id, {
    cascade: true,
    onDelete: 'CASCADE',
  })
  user: User;
}
