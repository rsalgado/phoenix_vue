<template>
  <div>  
    <h1>{{title}}</h1>
    <div>The current time is <span class="time">{{currentTime}}</span></div>
  </div>
</template>

<style>
  h1 {
    font-size: 1.5rem;
  }

  .time {
    font-weight: bold;
  }
</style>

<script>
  import {Socket} from "phoenix";
  import Vue from "vue";
  import Vuex from "vuex";

  Vue.use(Vuex);
  

  let store = new Vuex.Store({
    state: {
      currentTime: "No time available",
    },

    mutations: {
      setTime(state, payload) {
        state.currentTime = payload.body;
      }
    }
  });

  export default {
    plugins: [], // TODO: Consider wrapping the channels communication in a Vuex plugin
    store,

    data() {
      return {
        title: "Vue.js frontend for Phoenix Channels"
      };
    },

    computed: {
      currentTime() {
        return this.$store.state.currentTime;
      }
    }
  };

  // Connect to Phoenix socket
  const SOCKET_URL = "ws://localhost:4000/socket";
  let socket = new Socket(SOCKET_URL);
  socket.connect();

  // Get and join the channel
  let channel = socket.channel("clock:lobby", {});
  channel.join()
    .receive("ok", (payload) =>   console.log("Joined the channel successfully.", payload.messages))
    .receive("error", (payload) =>  console.log("Error joining the channel", payload.reason))
    .receive("timeout", () =>   console.log("Time out: Still waiting to join the channel..."));

  // Register handler to listen to `"update_time"` events from the channel
  channel.on("update_time", payload => {
    store.commit("setTime", payload);
  })
</script>
