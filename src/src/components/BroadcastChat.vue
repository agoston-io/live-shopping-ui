<template>
  <div class="card bg-dark mt-3 mt-lg-0 p-0 p-lg-2">
    <h5 class="card-title">Chat about {{ broadcastName }}...</h5>
    <div class="card-body" style="height: 390px; overflow-y: scroll; overflow-x: hidden" id="chat">
      <div class="col-12" v-if="$apollo.queries.oneChat.loading">
        Loading...
      </div>
      <!---->
      <div v-else v-for="item in oneChat.nodes" :key="item.id">
        <div class="d-flex justify-content-between">
          <p class="small mb-1">{{ item.user.username }}</p>
          <p class="small mb-1 text-muted">
            {{ tsToNiceElapsed(item.createdAt, "Now") }}
          </p>
        </div>
        <div class="d-flex flex-row justify-content-start">
          <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-chat/ava5-bg.webp" alt="avatar 1"
            style="width: 45px; height: 100%" />
          <div>
            <p class="small p-2 ms-3 mb-3 rounded-3 bg-secondary">
              {{ item.content }}
            </p>
          </div>
        </div>
      </div>
      <!---->
    </div>
    <div class="
        card-footer
        text-muted
        justify-content-start
        align-items-center
        p-0
      ">
      <form @submit.prevent="onSubmit">
        <div class="input-group mb-0">
          <input id="chatInput" type="text" class="form-control" v-model="v$.form.message.$model"
            v-on:keyup.enter="postMessage" required />
          <button v-if="$agostonClient.isAuthenticated()" :disabled="v$.form.$invalid" v-on:click="postMessage"
            class="btn btn-primary" type="button" style="padding-top: 0.55rem">
            <font-awesome-icon class="me-1" :icon="['far', 'paper-plane']" />
          </button>
          <router-link v-else class="btn btn-primary" :to="{ name: 'LoginPage' }">Login to chat</router-link>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
// Vue
import useVuelidate from "@vuelidate/core";
import { required, minLength, maxLength } from "@vuelidate/validators";
// JS Libraries
import tsToNiceElapsed from "../tsToNiceElapsed.js";
// GraphQL
import ONE_CHAT from "../graphql/oneChat.gql";
import ONE_CHAT_SUBSCRIPTION from "../graphql/oneChatSubscription.gql";
import CHAT_SEND_MESSAGE from "../graphql/chatAddMessage.gql";

export default {
  name: "broadcast-chat",
  props: ["broadcastId", "broadcastName"],
  setup() {
    return { v$: useVuelidate() };
  },
  data() {
    return {
      oneChat: {},
      form: {
        message: "",
      },
    };
  },
  validations() {
    return {
      form: {
        message: {
          required,
          min: minLength(1),
          max: maxLength(1024),
        },
      },
    };
  },
  apollo: {
    oneChat: {
      query: ONE_CHAT,
      variables() {
        return {
          broadcastId: parseInt(this.broadcastId),
        };
      },
      subscribeToMore: {
        document: ONE_CHAT_SUBSCRIPTION,
        variables() {
          return {
            topic: `chats`,
            broadcastId: parseInt(this.broadcastId),
          };
        },
        updateQuery: (previousResult, { subscriptionData }) => {
          return subscriptionData.data.listen.query;
        },
      },
    },
  },
  watch: {
    oneChat: {
      handler: function () {
        setTimeout(function () {
          let chat = document.getElementById("chat");
          chat.scrollTop = chat.scrollHeight;
        }, 50);
      },
      deep: true,
    },
  },
  methods: {
    postMessage() {
      const message = this.v$.form.message.$model;
      if (message.length > 0) {
        this.$apollo
          .mutate({
            mutation: CHAT_SEND_MESSAGE,
            variables: {
              message: message,
              broadcastId: parseInt(this.broadcastId),
            }
          })
          .then(() => {
            this.form.message = "";
          })
          .catch((error) => {
            console.error(error);
          });
      }
    },
  },
  computed: {
    tsToNiceElapsed,
  },
};
</script>