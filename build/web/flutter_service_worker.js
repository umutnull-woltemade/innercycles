'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"birth-chart.html": "b06679c8dd509cc93c60783edd4cf19c",
"flutter_bootstrap.js": "345a217fcde06be741b37ada47cc774a",
"synastry.html": "b503272cfcc28c9698c2d4e3d2cb80a6",
"profile.html": "53ea82de74276cd8077bdb738609703b",
"horoscope.html": "2b889810df2c7a6124a3fe7ee844aff1",
"celebrities.html": "0c3886c230146a66e4035d5aea712037",
"kozmoz.html": "bd064832cf21cbd65087b02481fa12e6",
"version.json": "c5286c2e4b1d5511a2d7f0b37e484ff1",
"year-ahead.html": "2ed5e22b3d416fe23fe2257f57b88d3f",
"monthly-horoscope.html": "417dafc96ef03d84aac3780dd7310e0b",
"index.html": "2d7d81176c556c4c0767d4ef9a87c51f",
"/": "2d7d81176c556c4c0767d4ef9a87c51f",
"vedic.html": "a0c8fb55192454323d97712b8998fff6",
"rituals.html": "de5c6dca395ef173a58fdaad468f9b41",
"main.dart.js": "22719406c06681e6e6ba444b6c539470",
".well-known/apple-app-site-association": "93999fc3df7aa7fee1858bd80cf00c30",
".well-known/apple-developer-domain-association.txt": "0e03c00486fbe3d43eb9491fd88d6eff",
"yearly-horoscope.html": "0a3c4184fac6a9409fa25958df3790a4",
"ruya/ruyada-deprem.html": "0895860fb056e9bee3bcad11930ffbee",
"ruya/ruyada-dugun.html": "660bf62e1326b2bc80195ad61e7304e4",
"ruya/ruyada-araba.html": "285af3cbd127a7388f0c7ea2fa7116bf",
"ruya/ruyada-karanlik.html": "01036a39afff2a9417ea7d887a606906",
"ruya/ruyada-olum.html": "1ad159363b071f696aa607bad49a71a4",
"ruya/ruyada-cocuk.html": "5b6fbe03dd76ac178c6b6f6c1ee03a0b",
"ruya/ruyada-ayna.html": "0a32d492be5ae331b5e8557198bff06f",
"ruya/ruyada-yukseklik.html": "de02f60651be0c97d9d095c3dbdd7d0b",
"ruya/ruyada-at.html": "2ee95bd365ab6e95cb3d1807777277a2",
"ruya/index.html": "649415e0cf73512f42ee40077c71ad96",
"ruya/ruyada-kar.html": "b729c10c728fc1e32497d55b889e1d15",
"ruya/ruyada-mezarlik.html": "03cec941273cca28b1547dad2fc62c6e",
"ruya/ruyada-dusmek.html": "132366a13e0744622db0e0838218645c",
"ruya/ruyada-cicek.html": "3a79c5eafc04b2f727594829e9b40321",
"ruya/ruyada-bebek.html": "b755cf2983295c702634b552ecd8796f",
"ruya/ruyada-yagmur.html": "df17df0cd4f85fb37934151469291f38",
"ruya/ruyada-deniz.html": "3edabc9ce43c9e163ef3b7ed193a486b",
"ruya/ruyada-doga.html": "848657359e40ccab416843bff81e08b9",
"ruya/ruyada-hastane.html": "020254f473ee5316854cf939a9bf0aca",
"ruya/ruyada-savas.html": "509dd7fbf8748b56688b70571c97e52d",
"ruya/ruyada-orman.html": "c6e7eb5b82796fe6f224ffeb12eb3c46",
"ruya/ruyada-ates.html": "318c376d99a26fba91bfb21668635abf",
"ruya/ruyada-kaybolmak.html": "a2af14e0927eb1c1df80b4cb15aa50e3",
"ruya/ruyada-kedi.html": "28b6941c89105405e1beb5237f60790c",
"ruya/ruyada-kavga.html": "f7ab8a56cf40219c46bcfc0cacd80a94",
"ruya/ruyada-dag.html": "ff3e458976ce01f46fb70a18394e0800",
"ruya/ruyada-eski-sevgili.html": "65fca9952f70ffa206a53eefcf295586",
"ruya/ruyada-dis-dokulmesi.html": "375f0de0bfed174efad4bd124c5fee15",
"ruya/ruyada-hastalik.html": "091646f0b0b93c504fb5707540f0b161",
"ruya/ruyada-para.html": "fa327c8eccec96ec8409e79d37b4b544",
"ruya/ruyada-su.html": "93c43de7b2c20eb66a7e48d6d2c3c1da",
"ruya/ruyada-aglamak.html": "cc5621940335557fc1282c70c0d59246",
"ruya/ruyada-telefon.html": "5f07048c99aa65387051ea720321c52d",
"ruya/ruyada-ucurum.html": "87f5b1ad39c26ce905f2d25dee75e331",
"ruya/ruyada-ucmak.html": "c538ca5f6843534bc057c2b35932e717",
"ruya/ruyada-ucak.html": "a31d635e02ee5076199f52b45b2b5de2",
"ruya/ruyada-hamile-kalmak.html": "75bc8272e0699722162fee9b67803f89",
"ruya/ruyada-ev.html": "fb099ec5c57eeb65a9183936e95ad84c",
"ruya/ruyada-yilan.html": "0af10cae4228e82163734595f7430624",
"ruya/ruyada-okul.html": "5b9ad8527a043069860cbea629e69fc7",
"ruya/ruyada-yol.html": "a4cce75d7dc6f0b2006c7a7320ed7924",
"ruya/ruyada-sinav.html": "ca1cabc045d624a097a79098ec9c8ed4",
"ruya/ruyada-kopek.html": "cf74e30b7ff629c78609f576a820fda4",
"ruya/ruyada-kovalanmak.html": "2e799dfdd07137ea0cca4fee3bc4959e",
"ruya/ruyada-gec-kalmak.html": "af5efcaf876567faed1fc1896205e310",
"ruya/ruyada-bogulmak.html": "aa80be96bad8fdd0fd862fb3536494f4",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"quiz.html": "589010d70bd7d104efa213a731158343",
"saturn-return.html": "4fd186b3a848a2bf5eb9818de4e32cd2",
"draconic.html": "45d374a3de8ce3fd51aaec1284c3faaf",
"glossary.html": "30ba809fae4b3342c6a2c840972cf9a1",
"favicon.png": "b152ad073139e24e13eb38ea67b90b20",
"sub.html": "9964236d7146b067f0907d18a65350ac",
"asteroids.html": "1ed228f72fba80d431731b83ee79ce2e",
"composite.html": "983678e2e6d5649a43b8c8d8cc123367",
"chakra.html": "3eca3b96e65ceef2835e0a2e9d21d3c7",
"icons/Icon-192.png": "ac3f426919518bcb8ed124c7ad68954c",
"icons/Icon-maskable-192.png": "45399dbb06320b2749711a581fedb21e",
"icons/Icon-maskable-512.png": "8297e73f68206c18aaeec1fef71e2a5f",
"icons/Icon-512.png": "da5a0c50c29df4482be1942473c93464",
"thanks.html": "1c3066196aee1da6ae07ead4d1fc273d",
"loading-test.html": "550df70f77a729860e96c17e3892eb2d",
"manifest.json": "e145508a49b139947c46f58e8a6eb859",
"progressions.html": "cf5b9e7685011844d3dfb7823efc96c4",
"weekly-horoscope.html": "b54fe8c9fadb403722b449e02ed98e52",
"api/health.json": "53e24ee64f0b7a63a02541b24a49c0c1",
"sitemap.xml": "2f939325c6b6f01f635439a349158700",
"numerology.html": "60d6c2db664e35e72fbe19f2a9b97f86",
"local-space.html": "493d69bad2fcddeffbdb37d14ff11ddb",
"robots.txt": "349f839a7fa4c8995ae590d13a16c7ae",
"settings.html": "f2ca399d0c456b171d2636fb75d47076",
"solar-return.html": "525c5de5164ecc7cd2afffa50e12cc11",
"timing.html": "cd2be87dcc15f996573794eb9f4fc215",
"assets/NOTICES": "f74461169930bac3c0c94f1df1511396",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "32adbb0cc8118737698eb984b1512b00",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/AssetManifest.bin": "32ba2210f60d15c2e8a614be3899da45",
"assets/fonts/MaterialIcons-Regular.otf": "664327ea4d2b5716490412244275d14c",
"assets/assets/l10n/tr.json": "1d06a48255f01c706a571461cfa46ae7",
"assets/assets/l10n/de.json": "26c338efd0e9a75661c4c20c662f32db",
"assets/assets/l10n/en.json": "a4e46d58117799d4c487bef735dbac1e",
"assets/assets/l10n/fr.json": "eb2905a011352ba6666df85a1010d298",
"assets/assets/brand/venus-logo/png/venus-logo-512.png": "8cf07ba229432820db75a5d074808bfb",
"assets/assets/brand/venus-logo/png/venus-logo-96.png": "b23e301a550c1f762e60151b55b0eb8f",
"assets/assets/brand/venus-logo/png/venus-logo-1024.png": "ae99931a8e0a30781595dc433ab4f31c",
"assets/assets/brand/venus-logo/png/venus-appicon-noglow-1024.png": "7de33719a762855c6ae6d8feb6285a61",
"assets/assets/brand/venus-logo/png/venus-logo-180.png": "5b9f5405ccc31bf08f94d795c6e9ffc6",
"assets/assets/brand/venus-logo/png/venus-logo-152.png": "68f3743080680bba82d62f614c0a72df",
"assets/assets/brand/venus-logo/png/venus-appicon-glow-1024.png": "d2fb444cfb54032e51348f328222c51c",
"assets/assets/brand/venus-logo/png/venus-logo-192.png": "7e5869b777f54e824be6e0878eba5f49",
"assets/assets/brand/venus-logo/png/venus-logo-144.png": "478dacf80bd312bbb95f49c9fabe823c",
"assets/assets/brand/venus-logo/png/venus-logo-48.png": "9cfd421c307d90605659d64cbe20b881",
"assets/assets/brand/venus-logo/png/venus-logo-120.png": "8ee2780158b9d81996824626991278f2",
"assets/assets/brand/venus-logo/png/venus-logo-256.png": "c1a6939b210685a6ab6fe4b23f6e638f",
"assets/assets/brand/venus-logo/png/venus-logo-72.png": "6dcaca22e6a3dd34139c657f3b12a950",
"assets/assets/brand/venus-logo/png/venus-planet-transparent.png": "94fc87163bdae17073fc16454a76c655",
"assets/assets/brand/VENUS_ONE_VISUAL_SYSTEM.md": "5be5374cbaa8d08ec8ca13e70accb151",
"tarot.html": "9767ac5f7bb35fde3ac34a2176907e2d",
"dreams.html": "4477da58c557dc1afc75b931568f2865",
"transits.html": "ccf2284ecf38404437deb38f7ed0aea9",
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
"premium.html": "e424b36c08628d6b6b0d107412deda8a",
"index-static.html": "ef61d1812f538928fe11f0be50a33434"};
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
