shared_context "shared targets" do
  let(:target_name) { "terryrichardson" }
  let(:target_tumblr) { target_name + ".tumblr.com" }  
  let(:target_post_id) { "331417553" }
  let(:target_post_url) { "http://terryrichardson.tumblr.com/post/331417553/peekasso" }
  let(:target_post_url2) { "terryrichardson.tumblr.com/post/331417553/peekasso" }
  let(:target_post_url3) { "terryrichardson.tumblr.com/post/331417553" }
  let(:target_post_url4) { "www.terryrichardson.tumblr.com/post/331417553" }
  let(:target_post_url5) { "terryrichardson.tumblr.com/post/331417553" }
  let(:bad_target_post_url) { "http://terryrichardson.tfumblr.com/post/331417553/peekasso" }
  let(:bad_target_post_url2) { "terryrichardson.tumrblr.com/post/331417553/peekasso" }
  let(:bad_target_post_url3) { "terryrichardson.tumbelr.com/post/331417553" }
  let(:target_reblog_id) { "221532252" }
  let(:target_reblog_key) { "xjqLOsiL" }
  let(:target_reblog_url) { "http://www.tumblr.com/reblog/221532252/xjqLOsiL?redirect_to=http%3A%2F%2Fterryrichardson.tumblr.com%2Fpost%2F221532252&source=iframe" }
  let(:target_reblog_id2) { "54773937436" }
  let(:target_reblog_key2) { "x59hPgR7" }
  let(:target_reblog_url2) { "http://www.tumblr.com/reblog/54773937436/x59hPgR7?redirect_to=%2Fdashboard" }
  let(:target_reblog_id3) { "54774163481" }
  let(:target_reblog_key3) { "2Ss9tBmk" }
  let(:target_reblog_url3) { "http://www.tumblr.com/reblog/54774163481/2Ss9tBmk" }

  let(:tofollow_target_url) { ["terryrichardson.tumblr.com"] }
end  

shared_context "shared links" do
  let(:links) { "http://terryrichardson.tumblr.com/post/332715869/terrysdiary-me-and-amy   
http://terryrichardson.tumblr.com/post/237460623/via-journal-du-design
http://www.tumblr.com/reblog/54774163481/2Ss9tBmk   
http://terryrichardson.tumblr.com/post/237446983/via-dosomething-studio  
http://terryrichardson.tumblr.com/post/217269945
http://suicide-muse.tumblr.com/post/54616176043 
http://www.tumblr.com/reblog/54773810226/HXKbdnPG
http://www.tumblr.com/reblog/221532252/xjqLOsiL?redirect_to=http%3A%2F%2Fterryrichardson.tumblr.com%2Fpost%2F221532252&source=iframe   
http://terryrichardson.tumblr.com/post/236187313/douglasmartini-january-jones-by-terry
http://www.tumblr.com/reblog/54773937436/x59hPgR7?redirect_to=%2Fdashboard
http://terryrichardson.tumblr.com/post/231095946/suicideblonde-amy-winehouse-photographed-by" }
  let(:ar_links) { links.lines( "\n" ) }
  let(:count_reblogs) { ar_links.count }
  let(:ar_tofollow) { ["terryrichardson.tumblr.com", "suicide-muse.tumblr.com", "c-isnenegro.tumblr.com", "douglasmartini.tumblr.com", "suicideblonde.tumblr.com"] }
end

shared_context "shared tumblrs" do
  let(:tumblrs) { "terryrichardson.tumblr.com
suicide-muse.tumblr.com
trendgraphy.tumblr.com" }
  let(:ar_tumblrs) { tumblrs.lines( "\n" ) }
  let(:count_followed) { ar_tumblrs.count }
end

shared_context "shared caption post" do
   let(:caption) { %Q{
The Boiler Room by
<em>
<a href="http://www.flickr.com/photos/42311564N00/9196902084/sizes/l/in/set-72157634452675984/" target="_blank">Sebastian Niedlich</a>
</em>
</p>
</blockquote>

<blockquote><p><a class="tumblr_blog" href="http://crystvllized.tumblr.com/post/52628833334/vintage-photography">crystvllized</a>:</p>
<blockquote>

<a href="https://secure.flickr.com/photos/71775774N00/138779654/in/photolist-dghmE-h35Rn-nD5A9-xmoXV-FJbbv-GMTgN-2rmHys-2tbDBU-4MxR5p-4MUsSe-4NSuTs-4Pg5Wc-4PNs3z-4UhLFj-51KCxw-51KCxA-51KCxE-51KFWf-54HwbA-58GXkV-5inow2-5DNPcu-5JgJG4-5T52Ct-5UcTXy-61EuXc-61EuXe-61EuXi-61EuXk-61EuXx-66EUqZ-6ieXBN-6oerp6-6v8CDX-6A84ud-6B6JRS-6J9keq-6Voa5Y-6VPsm3-6X4U6S-739VYC-739VYJ-739VYN-77B4i6-78bChk-7bFV9E-7e3pgC-7e3pgG-7efbRr-7ej5gG-7ej5qf">photo moon</a>

<a href="https://secure.flickr.com/photos/enchantedgarden/">Enchanted</a>

<p>
<span>(via</span>
<a href="http://www.sallyscott.com/catalogue/12autumn/">2012 Autumn Collection from Nikukyu Issue #11 | Sally Scott</a>
<span>)</span>
</p>

<blockquote>
<p>
The Boiler Room by
<em>
<a href="http://www.flickr.com/photos/42311564N00/9196902084/sizes/l/in/set-72157634452675984/" target="_blank">Sebastian Niedlich</a>
</em>
</p>
</blockquote>

<blockquote>
<p>
<a href="http://www.matthias-heiderich.com">Matthias Heiderich,</a>
Bilbao 2013
</p>
</blockquote>

<blockquote>
<p>
<a href="http://www.flickr.com/photos/signsign86523/3842128766/in/photostream/lightbox/">
<em>blue memories</em>
</a>
</p>
</blockquote>

<p><a href="http://ohshesolovely.tumblr.com/post/54988912158/marine-vacth-by-paolo-roversi" class="tumblr_blog">ohshesolovely</a>:</p>

<blockquote><p>Marine Vacth by Paolo Roversi</p></blockquote>

<p>
<a href="http://visualoptimism.blogspot.jp/2013/07/cache-and-carry-bette-franke-by-paul.html" target="_blank">Cache and CARRY - VOGUE UK August 2013 | Bette Franke By Paul Wetherell</a>
</p>

<small>
<a target="_blank" href="http://www.polyvore.com/ignore_me_im_dying_x_x/set?.embedder=2689265&.svc=tumblr&id=88758056">Ignore me Im dying x_x</a>
by
<a target="_blank" href="http://mich-0524.polyvore.com/?.embedder=2689265&.svc=tumblr">mich-0524</a>
featuring
<a target="_blank" href="http://www.polyvore.com/juicy_couture/shop?brand=Juicy+Couture">juicy couture</a>
 liked on Polyvore
</small>

<p>
Carrie Bradshaw on We Heart It.
<a href="http://weheartit.com/entry/66354019/via/keepallmysecret" target="_blank">http://weheartit.com/entry/66354019/via/keepallmysecret</a>
</p>

<p>
<a href="http://overblackwaterpark.tumblr.com">http://overblackwaterpark.tumblr.com</a>
</p>
<p>
<a href="http://goodit.tumblr.com/">goodit</a>
</p>
<p>
<a href="http://www.tumblr.com/follow/overblackwaterpark">http://www.tumblr.com/follow/overblackwaterpark</a>
</p>



<p>
<a href="http://romanticnaturalism.tumblr.com/post/54923390988/let-it-rain-valeria-dmitrienko-in-alexander" class="tumblr_blog" target="_blank">romanticnaturalism</a>
:
</p>
<blockquote>
<p>
<em>Let It Rain</em>
- Valeria Dmitrienko in Alexander McQueen photographed by Nisian Hughes for Harper s Bazaar US August 2013
</p>
</blockquote>


<div class="post_body">
<p>
<a href="http://afleshfesten.tumblr.com/post/49434925020/damned" target="_blank" draggable="false">afleshfesten</a>
:
</p>
<blockquote>
<p>Damned !</p>
</blockquote>
</div>


<p>
<a class="tumblr_blog" href="http://abandonedography.com/post/55211207965/the-boiler-room-by-sebastian-niedlich" target="_blank">abandonedography</a>
:
</p>
<blockquote>
<p>
The Boiler Room by
<em>
<a href="http://www.flickr.com/photos/42311564N00/9196902084/sizes/l/in/set-72157634452675984/" target="_blank">Sebastian Niedlich</a>
</em>
</p>
</blockquote>

<blockquote><p><a class="tumblr_blog" href="http://crystvllized.tumblr.com/post/52628833334/vintage-photography">crystvllized</a>:</p>
<blockquote>

<p>
<span>(via</span>
<a href="http://www.sallyscott.com/catalogue/12autumn/">2012 Autumn Collection from Nikukyu Issue #11 | Sally Scott</a>
<span>)</span>
</p>

<blockquote>
<p>
<a href="http://www.matthias-heiderich.com">Matthias Heiderich,</a>
Bilbao 2013
</p>
</blockquote>

<blockquote>
<p>
<a href="http://www.flickr.com/photos/signsign86523/3842128766/in/photostream/lightbox/">
<em>blue memories</em>
</a>
</p>
</blockquote>

} }
  let(:ar_links_caption_tumblrs) { [ "ohshesolovely.tumblr.com", "overblackwaterpark.tumblr.com", "goodit.tumblr.com", "romanticnaturalism.tumblr.com", "afleshfesten.tumblr.com", "crystvllized.tumblr.com" ] }
  let(:source) { "goodit.tumblr.com" }

  let(:link_follow) { "http://ze-aesthete.tumblr.com/post/54992829267/romanticnaturalism-let-it-rain-valeria" }
  let(:count_caption_links_to_follow) { 1 }
end

shared_context "shared tags" do
  let(:tags) { [ "test it !" ] }
  let(:str_all_tags) { get_tumblr_test_tags + ", " + tags.join(", ") }
  let(:all_tags) { str_all_tags.split(", ") }
end  