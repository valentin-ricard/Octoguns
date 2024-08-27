import { writable } from "svelte/store";
import { SetupResult } from "./dojo/setup";
import { Bullet } from "./dojo/typescript/models.gen";
import { SessionMeta } from "./dojo/typescript/models.gen";

export const bullets = writable<any>();
export const characters = writable<any>();
export const current_session_id = writable<number>();
export const current_session = writable<SessionMeta>();
export const moves = writable<any>([]);

