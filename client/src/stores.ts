import { writable } from "svelte/store";
import { SetupResult } from "./dojo/setup";
//import { CharacterMove } frpm ./dojo/bindings/typescript/models.gen

export const dojoStore = writable<SetupResult>();
export const modelsStore = writable<any>();

export const pending_moveStore = writable<any>();