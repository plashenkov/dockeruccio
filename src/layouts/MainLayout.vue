<template>
  <header>
    <div class="content-wrapper">
      <div class="logo"></div>

      <div class="search-wrapper">
        <svg class="search-icon" viewBox="0 0 24 24">
          <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
        </svg>

        <input class="search-input" placeholder="Search Images" v-model="search">

        <svg class="search-clear" viewBox="0 0 24 24" v-show="search" @click="search = ''">
          <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
        </svg>

        <div class="search-border"></div>
      </div>
    </div>
  </header>

  <main>
    <div class="content-wrapper">
      <div v-if="loading" class="loader-wrapper">
        <div class="lds-ellipsis"><div></div><div></div><div></div><div></div></div>
      </div>

      <div v-else-if="error" class="no-images">Error loading images</div>

      <div v-else-if="!filteredImages.length" class="no-images">No images found</div>

      <div v-for="image of filteredImages" class="image" :class="{'is-collapsed': image.collapsed}" :key="image.name">
        <div class="image-title" @click="toggleImage(image)">
          {{image.name}}

          <svg viewBox="0 0 1000 1000">
            <g><path d="M887.2,209.2L499.7,589.1L112.8,209.7L10,310.5l489.7,480.3L990,310L887.2,209.2z"/></g>
          </svg>
        </div>

        <div class="image-tags" :style="{height: tagsHeight(image) + 'px'}">
          <div v-if="!image.tags.length" class="loader-wrapper">
            <div class="lds-ellipsis"><div></div><div></div><div></div><div></div></div>
          </div>

          <table v-else>
            <thead>
              <tr>
                <th>Tag</th>
                <th class="image-name">Link</th>
                <th class="is-right">Size</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="tag of image.tags" class="image-tag" :key="tag.tag">
                <td>{{tag.tag}}</td>
                <td class="image-name">
                  <span class="image-copy" @click="copyToClipboard(domain + '/' + image.name + ':' + tag.tag)">
                    <svg viewBox="0 0 24 24">
                      <path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/>
                    </svg>
                  </span>
                  <span>{{domain}}/{{image.name}}:{{tag.tag}}</span>
                </td>
                <td class="is-right">{{fileSize(tag.size)}}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </main>
</template>

<style>
  @import 'modern-normalize';

  html, body {
    overscroll-behavior: none;
  }

  body {
    background: #f5f5f7;
    color: #222;
  }
</style>

<style scoped>
  .content-wrapper {
    padding: 0 20px;
    margin: 0 auto;
    max-width: 1024px;
  }

  header {
    background: linear-gradient(90deg, #165e94, #2496ed);
    box-shadow:
      rgba(0, 0, 0, 0.2) 0 2px 4px -1px,
      rgba(0, 0, 0, 0.14) 0 4px 5px 0,
      rgba(0, 0, 0, 0.12) 0 1px 10px 0;
  }

  header .content-wrapper {
    height: 64px;
    display: flex;
    align-items: center;
  }

  .logo {
    width: 40px;
    height: 40px;
    cursor: pointer;
    background: url(/images/logo.png) no-repeat;
    background-size: 40px 40px;
  }

  .search-wrapper {
    position: relative;
    margin-left: 16px;
    flex: auto;
    display: flex;
  }

  .search-icon {
    position: absolute;
    pointer-events: none;
    width: 24px;
    height: 24px;
    fill: #fff;
    top: 5px;
    left: 0;
  }

  .search-input {
    background: transparent;
    border: none;
    outline: none;
    height: 32px;
    font: inherit;
    padding: 4px 26px 4px 32px;
    color: #fff;
    flex: auto;
  }

  .search-input::placeholder {
    color: rgba(255, 255, 255, 0.5);
  }

  .search-clear {
    position: absolute;
    cursor: pointer;
    width: 20px;
    height: 20px;
    fill: #fff;
    opacity: 0.5;
    top: 6px;
    right: 3px;
  }

  .search-clear:hover {
    opacity: 0.8;
  }

  .search-border {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    height: 2px;
    background: #fff;
    pointer-events: none;
    transform: scaleX(0);
    transition: transform 0.2s cubic-bezier(0, 0, 0.2, 1) 0s;
  }

  .search-wrapper input:hover ~ .search-border,
  .search-wrapper input:focus ~ .search-border,
  .search-clear:hover ~ .search-border,
  .search-clear:active ~ .search-border {
    transform: scaleX(1);
  }

  main .content-wrapper {
    padding: 20px 10px 60px;
  }

  .image {
    background: #fff;
    border-radius: 4px;
    margin: 12px 0;
    box-shadow:
      0 1px 2px rgba(0, 0, 0, 0.1),
      0 0 1px rgba(0, 0, 0, 0.2);
    transition: box-shadow 0.3s ease;
    overflow: hidden;
  }

  .image:hover {
    box-shadow:
      0 1px 2px rgba(0, 0, 0, 0.1),
      0 0 1px rgba(55, 61, 125, 0.9),
      inset 0 0 0 2px rgba(55, 68, 125, 0.15);
  }

  .image-title {
    position: relative;
    padding: 14px 14px 14px 46px;
    cursor: pointer;
    font-weight: bold;
    user-select: none;
    background: url(/images/image.png) 14px 50% no-repeat;
    background-size: 20px 20px;
  }

  .image-title svg {
    position: absolute;
    right: 14px;
    top: 14px;
    width: 20px;
    fill: #aaa;
    transition: transform 0.3s ease;
    transform: rotate(180deg);
  }

  .image.is-collapsed .image-title svg {
    transform: rotate(0);
  }

  .image-tags {
    transition: height 0.3s ease;
  }

  .image.is-collapsed .image-tags {
    height: 0 !important;
  }

  .image-tags table {
    width: 100%;
    border-collapse: collapse;
  }

  .image-tags th {
    text-transform: uppercase;
    text-align: left;
    color: #777;
    font-size: 11px;
    font-weight: normal;
    height: 30px;
    cursor: default;
    user-select: none;
  }

  .image-tags td {
    height: 36px;
  }

  .image-tags th,
  .image-tags td {
    padding-right: 14px;
    white-space: nowrap;
  }

  .image-tags th:first-child,
  .image-tags td:first-child {
    padding-left: 14px;
  }

  .image-tags .is-right {
    text-align: right;
  }

  th.image-name {
    padding-left: 6px;
  }

  td.image-name > * {
    vertical-align: middle;
  }

  .image-copy {
    cursor: pointer;
    display: inline-block;
    width: 24px;
    height: 24px;
    border-radius: 50%;
    text-align: center;
    padding-top: 5px;
    margin-right: 4px;
    user-select: none;
    transition: background-color 0.2s ease;
  }

  .image-copy:hover {
    background: #eee;
  }

  .image-copy:active {
    background: #e0e0e0;
  }

  .image-copy svg {
    width: 15px;
    height: 15px;
    fill: #777;
  }

  .no-images {
    color: #b5b5b5;
    text-align: center;
    padding-top: 24px;
    font-size: 30px;
  }

  .loader-wrapper {
    text-align: center;
  }

  .lds-ellipsis {
    display: inline-block;
    position: relative;
    width: 80px;
    height: 13px;
  }

  .lds-ellipsis div {
    position: absolute;
    top: 0;
    width: 13px;
    height: 13px;
    border-radius: 50%;
    background: #d7d7d7;
    animation-timing-function: cubic-bezier(0, 1, 1, 0);
  }

  .lds-ellipsis div:nth-child(1) {
    left: 8px;
    animation: lds-ellipsis1 0.6s infinite;
  }

  .lds-ellipsis div:nth-child(2) {
    left: 8px;
    animation: lds-ellipsis2 0.6s infinite;
  }

  .lds-ellipsis div:nth-child(3) {
    left: 32px;
    animation: lds-ellipsis2 0.6s infinite;
  }

  .lds-ellipsis div:nth-child(4) {
    left: 56px;
    animation: lds-ellipsis3 0.6s infinite;
  }

  @keyframes lds-ellipsis1 {
    0% {
      transform: scale(0);
    }

    100% {
      transform: scale(1);
    }
  }

  @keyframes lds-ellipsis3 {
    0% {
      transform: scale(1);
    }

    100% {
      transform: scale(0);
    }
  }

  @keyframes lds-ellipsis2 {
    0% {
      transform: translate(0, 0);
    }

    100% {
      transform: translate(24px, 0);
    }
  }
</style>

<script>
  async function get(url, options = {}) {
    return fetch('/v2/' + url, options).then(r => r.json())
  }

  export default {
    data() {
      return {
        domain: location.hostname,
        loading: true,
        error: false,
        search: '',
        images: [],
      }
    },

    computed: {
      filteredImages() {
        const search = this.search.trim().toLowerCase()
        return search
          ? this.images.filter(i => i.name.toLowerCase().includes(search))
          : this.images
      }
    },

    async mounted() {
      try {
        const response = await get('_catalog')
        this.images = response.repositories.sort().map(name => ({
          name,
          collapsed: true,
          tags: []
        }))
      } catch {
        this.error = true
      } finally {
        this.loading = false
      }
    },

    methods: {
      async toggleImage(image) {
        image.collapsed = !image.collapsed
        if (image.collapsed || image.tags.length) return

        const response = await get(image.name + '/tags/list')

        const tags = response.tags
          .sort((a, b) => b.localeCompare(a, undefined, {numeric: true, sensitivity: 'base'}))
          .map(tag => ({tag}))

        const sizes = await Promise.all(tags.map(tag => get(image.name + '/manifests/' + tag.tag, {
          headers: {
            accept: 'application/vnd.docker.distribution.manifest.v2+json'
          },
        })))

        tags.forEach((tag, i) => tag.size = sizes[i].layers.reduce((acc, layer) => acc + layer.size, 0))

        image.tags = tags
      },

      tagsHeight(image) {
        return image.tags.length * 36 + 40
      },

      fileSize(b) {
        let u = 0, s = 1024
        while (b >= s || -b >= s) {
          b /= s
          u++
        }
        return (u ? b.toFixed(2) + ' ' : b) + ' KMGTPEZY'[u] + 'B'
      },

      copyToClipboard(text) {
        navigator.clipboard.writeText(text)
      }
    }
  }
</script>
