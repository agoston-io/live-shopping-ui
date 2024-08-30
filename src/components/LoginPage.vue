<template>
  <main class="container" style="margin-top: 15%; margin-bottom: 5%">
    <div class="row justify-content-center">
      <div class="col-10 col-lg-3 d-grid gap-2">
        <button
          class="btn btn-primary"
          @click="
            $agostonClient.loginOrSignUpFromProvider({
              options: { redirectSuccess: '/', redirectError: '/login' },
            })
          "
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="16"
            height="16"
            fill="currentColor"
            class="bi bi-google"
            viewBox="0 0 16 16"
          >
            <path
              d="M15.545 6.558a9.42 9.42 0 0 1 .139 1.626c0 2.434-.87 4.492-2.384 5.885h.002C11.978 15.292 10.158 16 8 16A8 8 0 1 1 8 0a7.689 7.689 0 0 1 5.352 2.082l-2.284 2.284A4.347 4.347 0 0 0 8 3.166c-2.087 0-3.86 1.408-4.492 3.304a4.792 4.792 0 0 0 0 3.063h.003c.635 1.893 2.405 3.301 4.492 3.301 1.078 0 2.004-.276 2.722-.764h-.003a3.702 3.702 0 0 0 1.599-2.431H8v-3.08h7.545z"
            />
          </svg>
          <span class="ms-2">Login with Google</span>
        </button>
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
    };
  },
  methods: {
    async loginWithUserPassword() {
      this.$agostonClient
        .loginOrSignUpWithUserPassword({
          username: this.loginUsername,
          password: this.loginPassword,
          options: {
            free_value: {
              displayName: this.loginUsername,
            },
            redirectSuccess: "/",
          },
        })
        .then((session) => {
          console.log(`auth_success: ${JSON.stringify(session)}`);
          window.location.href = "/";
        })
        .catch((error) => {
          console.log(`auth_error: ${error}`);
        });
    },
  },
};
</script>
