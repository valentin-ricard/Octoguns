import { writable, derived, get } from "svelte/store";
import {
  defineQuery,
  getComponentValue,
  Has,
  isComponentUpdate,
} from "@dojoengine/recs";
import type {
  Component,
  ComponentValue,
  Entity,
  Schema,
} from "@dojoengine/recs";

export function createComponentValueStore<S extends Schema>(
  component: Component<S>,
  entityStore: {
    subscribe: (callback: (value: Entity | undefined) => void) => () => void;
  },
  defaultValue?: ComponentValue<S>
) {
  const store = writable<ComponentValue<S> | undefined>(undefined);

  return derived(
    entityStore,
    ($entity, set) => {
      set(
        $entity != null
          ? (getComponentValue(component, $entity) as ComponentValue<S>)
          : (defaultValue as ComponentValue<S>)
      );

      if ($entity == null) return;

      const queryResult = defineQuery([Has(component)], { runOnInit: false });
      const subscription = queryResult.update$.subscribe((update) => {
        if (isComponentUpdate(update, component) && update.entity === $entity) {
          const [nextValue] = update.value;
          set(nextValue as ComponentValue<S>);
        }
      });

      return () => subscription.unsubscribe();
    },
    defaultValue
  );
}