import { writable } from "svelte/store";
import { SetupResult } from "./dojo/setup";
import { Bullet } from "./dojo/bindings/typescript/models.gen"

export const dojoStore = writable<SetupResult>();
export const modelsStore = writable<any>();

export const bullets = writable<Bullet>();