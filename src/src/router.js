import { createRouter, createWebHistory } from "vue-router";
import LandingPage from "@/components/LandingPage";
import LoginPage from "@/components/LoginPage";
import NotFound from "@/components/NotFound";

const routes = [
    {
        path: "/",
        name: "LandingPage",
        component: LandingPage,
    },
    {
        path: "/login",
        name: "LoginPage",
        component: LoginPage,
    },
    {
        path: "/:catchAll(.*)",
        name: 'NotFound',
        component: NotFound,
    },
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

export default router;