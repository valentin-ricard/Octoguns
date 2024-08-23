import { writable } from "svelte/store";
import { SetupResult } from "./dojo/setup";

export const dojoStore = writable<SetupResult>();
export const modelsStore = writable<any>();