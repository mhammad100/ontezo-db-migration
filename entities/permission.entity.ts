import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  OneToMany,
  Index,
} from 'typeorm';
import Model from './base.entity';
import { RolePermission } from './role-permission.entity';

@Entity({ name: 'permissions' })
@Index('permission_name_idx', ['name'], { unique: true })
export class Permission extends Model {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  name: string; // Example: 'READ_USER', 'WRITE_USER', 'DELETE_USER'

  @Column({ nullable: true, name: 'permission_type' })
  permissionType: string; // Example: 'CRUD', 'READ', 'WRITE', etc.

  @Column({ nullable: true })
  feature: string; // e.g., "General", "Project Management", "CRM"

  @OneToMany(
    () => RolePermission,
    (rolePermission) => rolePermission.permission,
  )
  rolePermissions: RolePermission[];
}
