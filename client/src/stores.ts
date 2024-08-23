import { writable } from "svelte/store";
import { IDojo } from "./dojo/setup";

export const dojoStore = writable<IDojo>();