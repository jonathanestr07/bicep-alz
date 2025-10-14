-- Fix paths in images
function Image(el)
  -- Check if the image has a source and if it starts with '../'
  if el.src and el.src:sub(1,3) == '../' then
    -- Remove '../' from the start of the source URL
    el.src = el.src:sub(4)
  end
  return el
end

-- Remove anything within double square brackets, used in Gollum Wiki
function Str(el)
  el.text = el.text:gsub('%[%[.-%]%]', '')
  return el
end
