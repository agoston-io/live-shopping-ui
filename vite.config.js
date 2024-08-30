import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import graphql from '@rollup/plugin-graphql';
const fs = require('fs');
const path = require("path");

export default defineConfig({
    plugins: [vue(), graphql()],
    resolve: {
        alias: {
            "@": path.resolve(__dirname, "./src"),
        },
    },
    server: {
        https: {
            key: fs.readFileSync('./dev/live-shopping.dev.local.key'),
            cert: fs.readFileSync('./dev/live-shopping.dev.local.crt'),
        },
    }
})
