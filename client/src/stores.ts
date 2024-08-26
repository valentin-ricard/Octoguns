import { writable } from "svelte/store";
import { SetupResult } from "./dojo/setup";
import { Bullet } from "./dojo/typescript/models.gen"


export const bullets = writable<Bullet>();
export const current_session = writable<number>();