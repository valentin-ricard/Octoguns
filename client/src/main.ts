import App from './App.svelte';
import { dojoConfig } from "../dojoConfig.ts";
import { setup } from "./dojo/setup.ts";
import { dojoStore } from './stores.ts';

let result= await setup(dojoConfig);

dojoStore.set(result);

const app = new App({
	target: document.body
});

export default app;
