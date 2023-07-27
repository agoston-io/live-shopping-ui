<template>
  <div class="row">
    <div class="col-2" v-if="!isMobile()">
      <TopChannels />
    </div>
    <div class="col-12 col-lg-10 bg-dark">
      <div class="row">
        <div class="col-12" v-if="$apollo.queries.oneBroadcast.loading">
          Loading...
        </div>
        <div class="col-12" v-else>
          <div class="row g-0">
            <div class="col-12 col-lg-8 bg-dark">
              <div class="row">
                <div class="col-12 p-0">
                  <img src="https://picsum.photos/800/400" class="card-img-top" />
                </div>
                <div class="col-12 py-0 px-1 mt-2">
                  <h4 class="mb-0 pb-0">
                    {{ oneBroadcast.nodes[0].name }}
                  </h4>
                </div>
                <div class="col-12 py-0 px-1">
                  <a v-bind:href="'?channel=' + oneBroadcast.nodes[0].channel.id
                    ">
                    {{ oneBroadcast.nodes[0].channel.name }}
                  </a>
                </div>
              </div>
            </div>
            <div class="col-4 bg-dark" v-if="!isMobile()">
              <BroadcastChat :broadcast_id="oneBroadcast.nodes[0].id" />
            </div>
          </div>
          <div class="row g-0 mt-2">
            <div class="col-12 bg-dark">
              <ChannelProducts :channelId="oneBroadcast.nodes[0].channelId" />
            </div>
          </div>
        </div>

        <div class="col-12 mt-4 fs-4 px-1 px-lg-2">More Livestreams</div>
        <div class="col-12">
          <div class="row">
            <div class="col-12 col-lg-3 card p-0 p-lg-2 bg-transparent border-0" v-for="item in broadcasts.edges"
              :key="item.node.id">
              <img src="https://picsum.photos/300/100" class="card-img-top" />
              <div class="card-body bg-dark px-1 px-lg-2">
                <h5 class="
                    card-title
                    text-truncate
                    mb-0
                    d-flex
                    justify-content-between
                  ">
                  <a v-bind:href="'?broadcast=' + item.node.id">{{
                    item.node.name
                  }}</a>
                  <div>
                    <font-awesome-icon class="me-1" :icon="['fas', 'thumbs-up']" />{{ item.node.liked }}
                  </div>
                </h5>
                <p class="card-text text-truncate mb-0">
                  <a v-bind:href="'?channel=' + item.node.channel.id">
                    {{ item.node.channel.name }}
                  </a>
                </p>
                <span class="
                    position-absolute
                    top-0
                    end-0
                    badge
                    rounded-pill
                    bg-primary
                  " style="margin-top: 15px; margin-right: 15px">
                  {{ tsToNiceElapsed(item.node.liveEndedAt, "Live") }}
                </span>
              </div>
            </div>
            <div class="col-3 card p-2 bg-transparent p-0 border-0"
              v-if="!isMobile() && !$apollo.queries.broadcasts.loading">
              <button :class="{ 'd-none': !broadcasts.pageInfo.hasNextPage }" v-on:click="fetchMoreBroadcasts"
                class="btn btn-dark" type="button" style="height: 100%">
                <font-awesome-icon class="me-1" :icon="['fas', 'angle-double-right']" size="4x" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
// Project libraries
import tsToNiceElapsed from "../tsToNiceElapsed.js";
import isMobile from "../isMobile.js";
// Project components
import BroadcastChat from "./BroadcastChat.vue";
import ChannelProducts from "./ChannelProducts.vue";
import TopChannels from "./TopChannels.vue";
// GraphQL
import ALL_BROADCASTS from "../graphql/broadcasts.gql";
import ONE_BROADCAST from "../graphql/oneBroadcast.gql";

export default {
  name: "live-shopping",
  components: {
    BroadcastChat,
    ChannelProducts,
    TopChannels,
  },
  data() {
    return {
      oneBroadcast: {},
      broadcasts: {},
    };
  },
  apollo: {
    oneBroadcast: {
      query: ONE_BROADCAST,
      variables() {
        return {
          id:
            parseInt(
              new URLSearchParams(window.location.search).get("broadcast")
            ) || undefined,
          channelId:
            parseInt(
              new URLSearchParams(window.location.search).get("channel")
            ) || undefined,
        };
      },
    },
    broadcasts: {
      query: ALL_BROADCASTS,
      variables() {
        return {
          channelId:
            parseInt(
              new URLSearchParams(window.location.search).get("channel")
            ) || undefined,
        };
      },
    },
  },
  methods: {
    isMobile,
    fetchMoreBroadcasts() {
      this.$apollo.queries.broadcasts.fetchMore({
        variables: {
          after: this.broadcasts.pageInfo.endCursor,
        },
      });
    },
    fetchMoreBroadcastsScrolling() {
      window.onscroll = () => {
        if (
          document.documentElement.scrollTop + window.innerHeight >=
          document.documentElement.offsetHeight - 5 &&
          this.isMobile() &&
          !this.$apollo.queries.broadcasts.loading
        ) {
          this.fetchMoreBroadcasts();
        }
      };
    },
  },
  mounted() {
    this.fetchMoreBroadcastsScrolling();
  },
  computed: {
    tsToNiceElapsed,
  },
};
</script>
