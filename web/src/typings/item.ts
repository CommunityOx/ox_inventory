export type ItemData = {
  name: string;
  label: string;
  stack: boolean;
  usable: boolean;
  close: boolean;
  count: number;
  description?: string;
  rarity?: number;
  buttons?: string[];
  ammoName?: string;
  image?: string;
};
