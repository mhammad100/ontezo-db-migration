import { Entity, Column } from 'typeorm';
import Model from './base.entity';

@Entity({ name: 'plans' })
export class Plan extends Model {
  @Column({ unique: true, name: 'stripe_price_id', nullable: true }) // ✅ Added missing price ID
  stripePriceId: string;

  @Column({ unique: true, name: 'stripe_product_id', nullable: true }) // ✅ Added missing product ID
  stripeProductId: string;

  @Column({ unique: true })
  name: string;

  @Column({ nullable: true })
  description: string;

  @Column({
    type: 'decimal',
    precision: 10,
    scale: 2,
    name: 'price_per_unit_amount',
  })
  pricePerUnitAmount: number;

  @Column()
  currency: string;

  @Column()
  interval: string; // 'month' or 'year'

  @Column({ default: true, name: 'is_active' })
  isActive: boolean;

  @Column({ type: 'json', nullable: false })
  features: unknown[]; // ✅ Explicitly define as JSON

  @Column({ nullable: true, name: 'trial_period_days' })
  trialPeriodDays: number;

  @Column({ default: false, name: 'is_custom' })
  isCustom: boolean;
}
