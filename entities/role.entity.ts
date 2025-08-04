import { Entity, Column, Index, ManyToMany, OneToMany, ManyToOne, JoinColumn } from 'typeorm';
import { User } from './user.entity';
import Model from './base.entity';
import { RolePermission } from './role-permission.entity';
import { Tenant } from './tenant.entity';

@Entity({ name: 'roles' })
@Index('role_tenant_name_unique', ['tenantId', 'name'], { unique: true })
export class Role extends Model {
  @Column({ unique: true })
  name: string; // Example: 'ADMIN', 'SUPER_ADMIN', 'VIEWER',"CUSTOM_ROLE"

  @Column({ nullable: true })
  label: string; // Example: 'Super Admin', 'Admin', 'Viewer'

  @Column({ nullable: true })
  description: string; // Example: 'has all permission to add users'

  @Column({ nullable: true, name: 'role_type' })
  roleType: string; // Example: 'Super Admin', 'Admin', 'Viewer'

  @Column({ nullable: true })
  feature: string; // e.g., "General", "Project Management", "CRM"

  @OneToMany(() => RolePermission, (rolePermission) => rolePermission.role)
  rolePermissions: RolePermission[];

  @ManyToMany(() => User, (user) => user.roles, { onDelete: 'CASCADE' })
  users: User[];
  
  @Column({ name: 'tenant_id', nullable: false })
  tenantId: number;

  @ManyToOne(() => Tenant, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'tenant_id' })
  tenant: Tenant;

}
