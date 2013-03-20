let s:source = {
      \ 'name': 'typescript_complete',
      \ 'kind': 'ftplugin',
      \ 'filetypes': { 'typescript': 1 },
      \ }
 
function! s:source.initialize()
  let s:member = 'false'
  let s:start = 0
endfunction
 
function! s:source.finalize()
endfunction
 
function! s:source.get_keyword_pos(cur_text)
  let s:member = 'false'
	let line = getline('.')
 
	let s:start = col('.') - 1
	" カーソルの左側にあるドットの位置を探す
	while s:start >= 0
		" ドットより先に空白文字かセミコロンが見つかった場合は補完をしない
		if line[s:start] =~ '[\s;]'
			let s:start = -1
			break
		endif
		" ドットを見つけたらループ終了
		if line[s:start-1] == '.'
      let s:member = 'true'
			break
		endif
		let s:start -= 1
	endwhile
	return s:start
endfunction
 
function! s:source.get_complete_words(cur_keyword_pos, cur_keyword_str)
  echo "flag"
  if !exists(g:typescript_tools_started)
    echo "not exists g:typescript_tools_started"
    return []
  endif

	if bufname('%') == ''
		return []
	endif

  if &modified
    call tss#update()
  endif

  let s:info = tss#cmd("completions".s:member, {'col':s:start})

  let s:result = []
  if type(s:info) == type({})
    for entry in s:info.entries
      if entry['name'] =~ '^'.a:cur_keyword_str
        call add(s:result, {'word': entry['name'], 'menu': entry['type']})
      endif
    endfor
  endif
  return s:result
endfunction

function! neocomplcache#sources#typescript_complete#define()
	return s:source
endfunction
