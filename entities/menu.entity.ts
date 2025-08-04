// src/menu/menu.entity.ts
import { Entity, Column, Tree, TreeChildren, TreeParent, Index } from 'typeorm';
import Model from './base.entity';

@Entity()
@Tree('closure-table') //Closure table stores relations between parent and child in a separate table
@Index(['name', 'isVisible', 'isActive', 'order', 'groupBy'])
export class Menu extends Model {
  @Column()
  name: string;

  @Column({ nullable: true })
  icon: string;

  @Column({ nullable: true, unique: true })
  route: string;

  @Column({ name: 'is_visible', type: 'boolean', default: true })
  isVisible: boolean;

  @Column({ name: 'is_active', default: true })
  isActive: boolean;

  @Column({ default: 0 })
  order: number;

  @Column({ name: 'group_by', nullable: true })
  groupBy: string;

  @TreeParent()
  parent: Menu;

  @TreeChildren()
  children: Menu[];
}
