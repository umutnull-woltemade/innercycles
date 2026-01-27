'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"birth-chart.html": "1fec4f48c9db7e8016934b10cf5568e5",
"flutter_bootstrap.js": "f0d6358a4b2dac04aebcad5db66900db",
"synastry.html": "4ffdf61920b3799a38b43db9210b0e48",
"profile.html": "e56c1a83008ce8a4a51d2bd6f7fbdbd2",
"horoscope.html": "0533b8c70c7b3eda5b459577af082609",
"celebrities.html": "50630d9b0845d9e5f6dffd7d22e4b08c",
"kozmoz.html": "e1874c07b45bf79d51f812074d05c690",
"version.json": "c5286c2e4b1d5511a2d7f0b37e484ff1",
"year-ahead.html": "a2dd4d506b14e4dbde37bbba2ff3dcca",
"monthly-horoscope.html": "da567061213373c06d6c242052d8dfb3",
"index.html": "83bf1cd6f5aaa6cc4ad4412e6d8b5691",
"/": "83bf1cd6f5aaa6cc4ad4412e6d8b5691",
"vedic.html": "06cd726091e1a6ae28e09dfad6b5d818",
"rituals.html": "2a553f9a72a16f8fcfa7e14201178979",
"main.dart.js": "71868627c3f45fbefdbb8f965ff7bfaf",
".well-known/apple-app-site-association": "93999fc3df7aa7fee1858bd80cf00c30",
".well-known/apple-developer-domain-association.txt": "0e03c00486fbe3d43eb9491fd88d6eff",
"yearly-horoscope.html": "b099271a3edc1ece41c85c48988f7658",
"ruya/ruyada-deprem.html": "6e41aa26796cb2c3b5a9b193ba2d745e",
"ruya/ruyada-dugun.html": "9feade09a1ca4efe48efc9c39e23398f",
"ruya/ruyada-araba.html": "af4dc6083689b39d2e623c5c0c87d5e7",
"ruya/ruyada-karanlik.html": "f399f58e71275c4d16604dd4039063f1",
"ruya/ruyada-olum.html": "59abc9515dfe53a517036192d2f96248",
"ruya/ruyada-cocuk.html": "0999745f64688a30a995bbc55186c490",
"ruya/ruyada-ayna.html": "282a30f699448967087ac19964d9dee0",
"ruya/ruyada-yukseklik.html": "92691a0585d8b9d53586116a955fd56b",
"ruya/ruyada-at.html": "f3b626039e8c2931a3c08f92770319c0",
"ruya/index.html": "b6322513f54bce02f4b9620cdf84cb44",
"ruya/ruyada-kar.html": "663c3e259a73aa5fa42a5c164609e6ee",
"ruya/ruyada-mezarlik.html": "6451782ad30356cb5f3742253f815bf1",
"ruya/ruyada-dusmek.html": "b8a8ddd4c01392980d172a117e4726a0",
"ruya/ruyada-cicek.html": "c6a0107469e392b7591dc5b8a173f980",
"ruya/ruyada-bebek.html": "38e670b183e622a0d40e6c359b14911a",
"ruya/ruyada-yagmur.html": "574773dc50b1996866427248b0b316f0",
"ruya/ruyada-deniz.html": "81d7d7647739d1dfb679d99f707823d1",
"ruya/ruyada-doga.html": "00b49c53afa1e0c17e457156d0e10bb4",
"ruya/ruyada-hastane.html": "0f79004a439d7608ab83c7228ba28a91",
"ruya/ruyada-savas.html": "3462b9812bba5b8694d47a4bbc136ab6",
"ruya/ruyada-orman.html": "2a841d8617aaf4a4ecb487701398baf6",
"ruya/ruyada-ates.html": "a5b472706b4b48c501d53ef23dd7f980",
"ruya/ruyada-kaybolmak.html": "fd22315915a4535cb4e49138edeca886",
"ruya/ruyada-kedi.html": "0b41d038dfda196a6578040f3c4adea2",
"ruya/ruyada-kavga.html": "c15b4dd0f548bf5563b5e6023e75a436",
"ruya/ruyada-dag.html": "9d772f3410fa0c25409c969069df8747",
"ruya/ruyada-eski-sevgili.html": "ae30a0f9724d42ba0bcc64e3e96e98bc",
"ruya/ruyada-dis-dokulmesi.html": "8560622cc82cadb6b7f1c3febc7e3afa",
"ruya/ruyada-hastalik.html": "30c9c4b2abb1ae669c301de604664d58",
"ruya/ruyada-para.html": "0e1b9c2106319bdf24a0d29bb31d0fa4",
"ruya/ruyada-su.html": "615cf247e71f51bb5dcd8e4ac4f191c3",
"ruya/ruyada-aglamak.html": "d06ac3b4f82c77dccb450d8335681541",
"ruya/ruyada-telefon.html": "5cf89ec3e962fe2a1806978a72b9825c",
"ruya/ruyada-ucurum.html": "9b97cb6a31ac4e780f7793c342210b25",
"ruya/ruyada-ucmak.html": "ebbe1d63df40e7ffe58929d6b63a0ba8",
"ruya/ruyada-ucak.html": "6ad93117353c6b5f04462e9a07b22195",
"ruya/ruyada-hamile-kalmak.html": "6c97e227543cb14da8c95811abb4ed4d",
"ruya/ruyada-ev.html": "5df007a46c6279b674868330f92d8008",
"ruya/ruyada-yilan.html": "0056b65275c17bbd058045306fcf897a",
"ruya/ruyada-okul.html": "c5ae918bb113cf62e69cbc007f795169",
"ruya/ruyada-yol.html": "402105c69701dd8556dedadbbcecbbcc",
"ruya/ruyada-sinav.html": "a9c1d1cc3d45491d5a972d00b50ad069",
"ruya/ruyada-kopek.html": "a32d92c39ea3ec7935401dba5f515326",
"ruya/ruyada-kovalanmak.html": "b8339718992aa2436512a82d7b672672",
"ruya/ruyada-gec-kalmak.html": "d80bea1144d8edda5c1e146b705e971d",
"ruya/ruyada-bogulmak.html": "192086683ea94cc0a6cb7afa157d359d",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"quiz.html": "dd494253ac93c1c78f90d5ed2db116c9",
"saturn-return.html": "b26f8fc0c8bae2b7b211be672876541d",
"draconic.html": "a1033326e8a08e16fe72f22d516bcc14",
"glossary.html": "4b1415352b3c7de7cadd7147e34ca284",
"favicon.png": "0d37aa6bc1ee2cb74b1eae0232520733",
"sub.html": "1e5ebb53af5e6dfe50bfd4f9b77c8a48",
"asteroids.html": "ef51437875c6d9843fc0c1670c5a99d2",
"composite.html": "3ae9f9fd8d522aa7507421d2fac4fe7d",
"chakra.html": "9e05aa68582f529a7405b71fffed117c",
"icons/Icon-192.png": "07a1b8c5a10e7ae26b8a2deefe2dd5cd",
"icons/Icon-maskable-192.png": "07a1b8c5a10e7ae26b8a2deefe2dd5cd",
"icons/Icon-maskable-512.png": "757b1fff5b202690e3f21f8ff118e8a9",
"icons/Icon-512.png": "b7f137ffaa6d57ea9296014fed03d0e9",
"thanks.html": "2d5a5fa5823c22a77fedb30d7f7b503d",
"manifest.json": "bd4049e7785300f129e44bc313a1409a",
"progressions.html": "4eafc558354f0c4bc06ec205d7601cc1",
"weekly-horoscope.html": "6420735a5d5a51ee319b379c76fe1cab",
"sitemap.xml": "812a65a891582bf21592b6ef26db56ec",
"numerology.html": "0751cdc13eca72fc216d74fa61e0ccd7",
"local-space.html": "cd55a45b4785e06be469c6ee23bedafb",
"robots.txt": "38b1b478b354205f7e0f99e327d69218",
"settings.html": "36e05a37b234350e2fd74984ce3019af",
"solar-return.html": "50b8fbff8410412e67dcfc6d37af9e1d",
"timing.html": "6af05c943d9bba6ef1f88ae1d75d1b4b",
"assets/NOTICES": "5774df751b685057c202479c642ecdd8",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "69a99f98c8b1fb8111c5fb961769fcd8",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/AssetManifest.bin": "693635b5258fe5f1cda720cf224f158c",
"assets/fonts/MaterialIcons-Regular.otf": "b61e691d40e19fb5395848cb42424eed",
"tarot.html": "869ade5e917b86837cc00db853a550b0",
"dreams.html": "98b15b4ef9218e82549835ba413de264",
"transits.html": "029cfd3a105d4a499b372bc5dafd5baa",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"premium.html": "79b7f4e33dfdf0458365c512abe2920a",
"index-static.html": "8293e4ce15d703849edf8a1077c2bd8c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
