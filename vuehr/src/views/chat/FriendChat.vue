<template>
    <div id="app">
        <div class="sidebar">
            <card></card>
            <list></list>
        </div>
        <div class="main">
            <message></message>
            <usertext></usertext>
        </div>
    </div>
</template>

<script>
    import card from '../../components/chat/card.vue'
    import list from '../../components/chat/list.vue'
    import message from '../../components/chat/message.vue'
    import usertext from '../../components/chat/usertext.vue'

    export default {
        name: 'FriendChat',
        data () {
            return {

            }
        },
        mounted:function() {
            this.$store.dispatch('initData');
        },
        components:{
            card,
            list,
            message,
            usertext
        }
    }
</script>

<style lang="scss" scoped>
    #app {
        width: 100%;
        height: 100%;
        overflow: hidden;
        border-radius: 0;
        margin: 0;
        display: flex;
        .sidebar {
            width: 200px;
            height: 100%;
            background-color: #2e3238;
            color: #f4f4f4;
            flex-shrink: 0;
        }
        .main {
            flex: 1;
            height: 100%;
            background-color: #eee;
            position: relative;
            overflow: hidden;
        }
    }
</style>