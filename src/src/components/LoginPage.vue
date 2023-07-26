<template>
    <main class="container" style="margin-top: 15%; margin-bottom: 5%;">
        <div class="row justify-content-center">
            <div class="col-3 d-grid gap-2">
                <button class="btn btn-primary"
                    @click="$agostonClient.loginOrSignUpFromProvider({ strategyName: 'google-oauth20', options: { redirectSuccess: '/', redirectError: '/login' } })">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-google"
                        viewBox="0 0 16 16">
                        <path
                            d="M15.545 6.558a9.42 9.42 0 0 1 .139 1.626c0 2.434-.87 4.492-2.384 5.885h.002C11.978 15.292 10.158 16 8 16A8 8 0 1 1 8 0a7.689 7.689 0 0 1 5.352 2.082l-2.284 2.284A4.347 4.347 0 0 0 8 3.166c-2.087 0-3.86 1.408-4.492 3.304a4.792 4.792 0 0 0 0 3.063h.003c.635 1.893 2.405 3.301 4.492 3.301 1.078 0 2.004-.276 2.722-.764h-.003a3.702 3.702 0 0 0 1.599-2.431H8v-3.08h7.545z" />
                    </svg> <span class="ms-2">Login with Google</span>
                </button>
                <p class="text-center mt-4 fw-bold">Or login with username/password:</p>
                <form id="loginForm" v-on:submit.prevent="onSubmit">
                    <div class="mb-3">
                        <label for="loginUsername" class="form-label">Username</label>
                        <input type="username" class="form-control" v-model="loginUsername" id="loginUsername">
                    </div>
                    <div class="mb-3">
                        <label for="loginPassword" class="form-label">Password</label>
                        <input type="password" class="form-control" v-model="loginPassword" id="loginPassword">
                    </div>
                </form>
                <button class="btn btn-primary" v-on:click="loginWithUserPassword">Login</button>
            </div>
        </div>
    </main>
    <Footer />
</template>

<script>
import Menu from "./Menu.vue";
import Footer from "./Footer.vue";

export default {
    components: {
        Menu,
        Footer,
    },
    data() {
        return {
            loginUsername: "",
            loginPassword: "",
        }
    },
    methods: {
        async loginWithUserPassword() {
            var err = await this.$agostonClient.loginOrSignUpWithUserPassword({
                username: this.loginUsername,
                password: this.loginPassword,
                data: {
                    displayName: this.loginUsername,
                }
            });
            if (err) {
                console.log(`Login error: ${err}`)
            } else {
                console.log("Login success")
                window.location.href = '/';
            }
        },
    }
};
</script>

