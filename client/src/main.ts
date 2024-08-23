import App from './App.svelte';
import { dojoConfig } from "../dojoConfig.ts";
import { setup } from "./dojo/setup.ts";
import { dojoStore, modelsStore } from './stores.ts';

let result= await setup(dojoConfig);
let models = await result.toriiClient.getAllEntities(1000, 0);
modelsStore.set(models);
dojoStore.set(result);


const app = new App({
	target: document.body
});

export default app;
