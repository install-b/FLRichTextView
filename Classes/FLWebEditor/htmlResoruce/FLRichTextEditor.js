/*
 * FLRichTextEditor
 */

var fl_editor = {};

// If we are using iOS or desktop
fl_editor.isUsingiOS = true;

// If the user is draging
fl_editor.isDragging = false;

// The current selection
fl_editor.currentSelection;

// The current editing image
fl_editor.currentEditingImage;

// The current editing link
fl_editor.currentEditingLink;

// The objects that are enabled
fl_editor.enabledItems = {};

// Height of content window, will be set by viewController
fl_editor.contentHeight = 244;

// Sets to true when extra footer gap shows and requires to hide
fl_editor.updateScrollOffset = false;

/**
 * The initializer function that must be called onLoad
 */
fl_editor.init = function() {
    
    $('#fl_editor_content').on('touchend', function(e) {
                                fl_editor.enabledEditingItems(e);
                                var clicked = $(e.target);
                                if (!clicked.hasClass('fl_active')) {
                                $('img').removeClass('fl_active');
                                }
                                });
    
    $(document).on('selectionchange',function(e){
                   fl_editor.calculateEditorHeightWithCaretPosition();
                   fl_editor.setScrollPosition();
                   fl_editor.enabledEditingItems(e);
                   });
    
    $(window).on('scroll', function(e) {
                 fl_editor.updateOffset();
                 });
    
    // Make sure that when we tap anywhere in the document we focus on the editor
    $(window).on('touchmove', function(e) {
                 fl_editor.isDragging = true;
                 fl_editor.updateScrollOffset = true;
                 fl_editor.setScrollPosition();
                 fl_editor.enabledEditingItems(e);
                 });
    $(window).on('touchstart', function(e) {
                 fl_editor.isDragging = false;
                 });
    $(window).on('touchend', function(e) {
                 if (!fl_editor.isDragging && (e.target.id == "fl_editor_footer"||e.target.nodeName.toLowerCase() == "html")) {
                 fl_editor.focusEditor();
                 }
                 });
    
}//end

fl_editor.updateOffset = function() {
    
    if (!fl_editor.updateScrollOffset)
        return;
    
    var offsetY = window.document.body.scrollTop;
    
    var footer = $('#fl_editor_footer');
    
    var maxOffsetY = footer.offset().top - fl_editor.contentHeight;
    
    if (maxOffsetY < 0)
        maxOffsetY = 0;
    
    if (offsetY > maxOffsetY)
    {
        window.scrollTo(0, maxOffsetY);
    }
    
    fl_editor.setScrollPosition();
}

// This will show up in the XCode console as we are able to push this into an NSLog.
fl_editor.debug = function(msg) {
    window.location = 'debug://'+msg;
}


fl_editor.setScrollPosition = function() {
    var position = window.pageYOffset;
    window.location = 'scroll://'+position;
}


fl_editor.setPlaceholder = function(placeholder) {
    
    var editor = $('#fl_editor_content');
    
    //set placeHolder
	editor.attr("placeholder",placeholder);
    //set focus			 
	editor.focusout(function(){
        var element = $(this);        
        if (!element.text().trim().length) {
            element.empty();
        }
    });
	
	
    
}

fl_editor.setFooterHeight = function(footerHeight) {
    var footer = $('#fl_editor_footer');
    footer.height(footerHeight + 'px');
}

fl_editor.getCaretYPosition = function() {
    var sel = window.getSelection();
    // Next line is comented to prevent deselecting selection. It looks like work but if there are any issues will appear then uconmment it as well as code above.
    //sel.collapseToStart();
    var range = sel.getRangeAt(0);
    var span = document.createElement('span');// something happening here preventing selection of elements
    range.collapse(false);
    range.insertNode(span);
    var topPosition = span.offsetTop;
    span.parentNode.removeChild(span);
    return topPosition;
}

fl_editor.calculateEditorHeightWithCaretPosition = function() {
    
    var padding = 50;
    var c = fl_editor.getCaretYPosition();
    
    var editor = $('#fl_editor_content');
    
    var offsetY = window.document.body.scrollTop;
    var height = fl_editor.contentHeight;
    
    var newPos = window.pageYOffset;
    
    if (c < offsetY) {
        newPos = c;
    } else if (c > (offsetY + height - padding)) {
        newPos = c - height + padding - 18;
    }
    
    window.scrollTo(0, newPos);
}

fl_editor.backuprange = function(){
    var selection = window.getSelection();
    var range = selection.getRangeAt(0);
    fl_editor.currentSelection = {"startContainer": range.startContainer, "startOffset":range.startOffset,"endContainer":range.endContainer, "endOffset":range.endOffset};
}

fl_editor.restorerange = function(){
    var selection = window.getSelection();
    selection.removeAllRanges();
    var range = document.createRange();
    range.setStart(fl_editor.currentSelection.startContainer, fl_editor.currentSelection.startOffset);
    range.setEnd(fl_editor.currentSelection.endContainer, fl_editor.currentSelection.endOffset);
    selection.addRange(range);
}

fl_editor.getSelectedNode = function() {
    var node,selection;
    if (window.getSelection) {
        selection = getSelection();
        node = selection.anchorNode;
    }
    if (!node && document.selection) {
        selection = document.selection
        var range = selection.getRangeAt ? selection.getRangeAt(0) : selection.createRange();
        node = range.commonAncestorContainer ? range.commonAncestorContainer :
        range.parentElement ? range.parentElement() : range.item(0);
    }
    if (node) {
        return (node.nodeName == "#text" ? node.parentNode : node);
    }
};

fl_editor.setBold = function() {
    document.execCommand('bold', false, null);
    fl_editor.enabledEditingItems();
}

fl_editor.setItalic = function() {
    document.execCommand('italic', false, null);
    fl_editor.enabledEditingItems();
}

fl_editor.setSubscript = function() {
    document.execCommand('subscript', false, null);
    fl_editor.enabledEditingItems();
}

fl_editor.setSuperscript = function() {
    document.execCommand('superscript', false, null);
    fl_editor.enabledEditingItems();
}

fl_editor.setStrikeThrough = function() {
    document.execCommand('strikeThrough', false, null);
    fl_editor.enabledEditingItems();
}

fl_editor.setUnderline = function() {
    document.execCommand('underline', false, null);
    fl_editor.enabledEditingItems();
}

fl_editor.setBlockquote = function() {
    var range = document.getSelection().getRangeAt(0);
    formatName = range.commonAncestorContainer.parentElement.nodeName === 'BLOCKQUOTE'
    || range.commonAncestorContainer.nodeName === 'BLOCKQUOTE' ? '<P>' : '<BLOCKQUOTE>';
    document.execCommand('formatBlock', false, formatName)
    fl_editor.enabledEditingItems();
}

fl_editor.removeFormating = function() {
    document.execCommand('removeFormat', false, null);
    fl_editor.enabledEditingItems();
}

fl_editor.setHorizontalRule = function() {
    document.execCommand('insertHorizontalRule', false, null);
    fl_editor.enabledEditingItems();
}

fl_editor.setHeading = function(heading) {
    var current_selection = $(fl_editor.getSelectedNode());
    var t = current_selection.prop("tagName").toLowerCase();
    var is_heading = (t == 'h1' || t == 'h2' || t == 'h3' || t == 'h4' || t == 'h5' || t == 'h6');
    if (is_heading && heading == t) {
        var c = current_selection.html();
        current_selection.replaceWith(c);
    } else {
        document.execCommand('formatBlock', false, '<'+heading+'>');
    }
    
    fl_editor.enabledEditingItems();
}

fl_editor.setParagraph = function() {
    var current_selection = $(fl_editor.getSelectedNode());
    var t = current_selection.prop("tagName").toLowerCase();
    var is_paragraph = (t == 'p');
    if (is_paragraph) {
        var c = current_selection.html();
        current_selection.replaceWith(c);
    } else {
        document.execCommand('formatBlock', false, '<p>');
    }
    
    fl_editor.enabledEditingItems();
}

// Need way to remove formatBlock
console.log('WARNING: We need a way to remove formatBlock items');

fl_editor.undo = function() {
    document.execCommand('undo', false, null);
    fl_editor.enabledEditingItems();
}

fl_editor.redo = function() {
    document.execCommand('redo', false, null);
    fl_editor.enabledEditingItems();
}

fl_editor.setOrderedList = function() {
    document.execCommand('insertOrderedList', false, null);
    fl_editor.enabledEditingItems();
}

fl_editor.setUnorderedList = function() {
    document.execCommand('insertUnorderedList', false, null);
    fl_editor.enabledEditingItems();
}

fl_editor.setJustifyCenter = function() {
    document.execCommand('justifyCenter', false, null);
    fl_editor.enabledEditingItems();
}

fl_editor.setJustifyFull = function() {
    document.execCommand('justifyFull', false, null);
    fl_editor.enabledEditingItems();
}

fl_editor.setJustifyLeft = function() {
    document.execCommand('justifyLeft', false, null);
    fl_editor.enabledEditingItems();
}

fl_editor.setJustifyRight = function() {
    document.execCommand('justifyRight', false, null);
    fl_editor.enabledEditingItems();
}

fl_editor.setIndent = function() {
    document.execCommand('indent', false, null);
    fl_editor.enabledEditingItems();
}

fl_editor.setOutdent = function() {
    document.execCommand('outdent', false, null);
    fl_editor.enabledEditingItems();
}

fl_editor.setFontFamily = function(fontFamily) {

	fl_editor.restorerange();
	document.execCommand("styleWithCSS", null, true);
	document.execCommand("fontName", false, fontFamily);
	document.execCommand("styleWithCSS", null, false);
	fl_editor.enabledEditingItems();
		
}

fl_editor.setTextColor = function(color) {
		
    fl_editor.restorerange();
    document.execCommand("styleWithCSS", null, true);
    document.execCommand('foreColor', false, color);
    document.execCommand("styleWithCSS", null, false);
    fl_editor.enabledEditingItems();
    // document.execCommand("removeFormat", false, "foreColor"); // Removes just foreColor
	
}

fl_editor.setBackgroundColor = function(color) {
    fl_editor.restorerange();
    document.execCommand("styleWithCSS", null, true);
    document.execCommand('hiliteColor', false, color);
    document.execCommand("styleWithCSS", null, false);
    fl_editor.enabledEditingItems();
}

// Needs addClass method

fl_editor.insertLink = function(url, title) {
    
    fl_editor.restorerange();
    var sel = document.getSelection();
    console.log(sel);
    if (sel.toString().length != 0) {
        if (sel.rangeCount) {
            
            var el = document.createElement("a");
            el.setAttribute("href", url);
            el.setAttribute("title", title);
            
            var range = sel.getRangeAt(0).cloneRange();
            range.surroundContents(el);
            sel.removeAllRanges();
            sel.addRange(range);
        }
    }
    else
    {
        document.execCommand("insertHTML",false,"<a href='"+url+"'>"+title+"</a>");
    }
    
    fl_editor.enabledEditingItems();
}

fl_editor.updateLink = function(url, title) {
    
    fl_editor.restorerange();
    
    if (fl_editor.currentEditingLink) {
        var c = fl_editor.currentEditingLink;
        c.attr('href', url);
        c.attr('title', title);
    }
    fl_editor.enabledEditingItems();
    
}//end

fl_editor.updateImage = function(url, alt) {
    
    fl_editor.restorerange();
    
    if (fl_editor.currentEditingImage) {
        var c = fl_editor.currentEditingImage;
        c.attr('src', url);
        c.attr('alt', alt);
    }
    fl_editor.enabledEditingItems();
    
}//end

fl_editor.updateImageBase64String = function(imageBase64String, alt) {
    
    fl_editor.restorerange();
    
    if (fl_editor.currentEditingImage) {
        var c = fl_editor.currentEditingImage;
        var src = 'data:image/jpeg;base64,' + imageBase64String;
        c.attr('src', src);
        c.attr('alt', alt);
    }
    fl_editor.enabledEditingItems();
    
}//end


fl_editor.unlink = function() {
    
    if (fl_editor.currentEditingLink) {
        var c = fl_editor.currentEditingLink;
        c.contents().unwrap();
    }
    fl_editor.enabledEditingItems();
}

fl_editor.quickLink = function() {
    
    var sel = document.getSelection();
    var link_url = "";
    var test = new String(sel);
    var mailregexp = new RegExp("^(.+)(\@)(.+)$", "gi");
    if (test.search(mailregexp) == -1) {
        checkhttplink = new RegExp("^http\:\/\/", "gi");
        if (test.search(checkhttplink) == -1) {
            checkanchorlink = new RegExp("^\#", "gi");
            if (test.search(checkanchorlink) == -1) {
                link_url = "http://" + sel;
            } else {
                link_url = sel;
            }
        } else {
            link_url = sel;
        }
    } else {
        checkmaillink = new RegExp("^mailto\:", "gi");
        if (test.search(checkmaillink) == -1) {
            link_url = "mailto:" + sel;
        } else {
            link_url = sel;
        }
    }
    
    var html_code = '<a href="' + link_url + '">' + sel + '</a>';
    fl_editor.insertHTML(html_code);
    
}

fl_editor.prepareInsert = function() {
    fl_editor.backuprange();
}

fl_editor.insertImage = function(url, alt) {
    fl_editor.restorerange();
    var html = '<img src="'+url+'" alt="'+alt+'" />';
    fl_editor.insertHTML(html);
    fl_editor.enabledEditingItems();
}

fl_editor.insertImageBase64String = function(imageBase64String, alt) {
    fl_editor.restorerange();
    var html = '<img src="data:image/jpeg;base64,'+imageBase64String+'" alt="'+alt+'" />';
    fl_editor.insertHTML(html);
    fl_editor.enabledEditingItems();
}

fl_editor.setHTML = function(html) {
    var editor = $('#fl_editor_content');
    editor.html(html);
}

fl_editor.insertHTML = function(html) {
    document.execCommand('insertHTML', false, html);
    fl_editor.enabledEditingItems();
}

fl_editor.getHTML = function() {
    
    // Images
    var img = $('img');
    if (img.length != 0) {
        $('img').removeClass('fl_active');
        $('img').each(function(index, e) {
                      var image = $(this);
                      var fl_class = image.attr('class');
                      if (typeof(fl_class) != "undefined") {
                      if (fl_class == '') {
                      image.removeAttr('class');
                      }
                      }
                      });
    }
    
    // Blockquote
    var bq = $('blockquote');
    if (bq.length != 0) {
        bq.each(function() {
                var b = $(this);
                if (b.css('border').indexOf('none') != -1) {
                b.css({'border': ''});
                }
                if (b.css('padding').indexOf('0px') != -1) {
                b.css({'padding': ''});
                }
                });
    }
    
    // Get the contents
    var h = document.getElementById("fl_editor_content").innerHTML;
    
    return h;
}

fl_editor.getText = function() {
    return $('#fl_editor_content').text();
}

fl_editor.isCommandEnabled = function(commandName) {
    return document.queryCommandState(commandName);
}

fl_editor.enabledEditingItems = function(e) {
    
    console.log('enabledEditingItems');
    var items = [];
    if (fl_editor.isCommandEnabled('bold')) {
        items.push('bold');
    }
    if (fl_editor.isCommandEnabled('italic')) {
        items.push('italic');
    }
    if (fl_editor.isCommandEnabled('subscript')) {
        items.push('subscript');
    }
    if (fl_editor.isCommandEnabled('superscript')) {
        items.push('superscript');
    }
    if (fl_editor.isCommandEnabled('strikeThrough')) {
        items.push('strikeThrough');
    }
    if (fl_editor.isCommandEnabled('underline')) {
        items.push('underline');
    }
    if (fl_editor.isCommandEnabled('insertOrderedList')) {
        items.push('orderedList');
    }
    if (fl_editor.isCommandEnabled('insertUnorderedList')) {
        items.push('unorderedList');
    }
    if (fl_editor.isCommandEnabled('justifyCenter')) {
        items.push('justifyCenter');
    }
    if (fl_editor.isCommandEnabled('justifyFull')) {
        items.push('justifyFull');
    }
    if (fl_editor.isCommandEnabled('justifyLeft')) {
        items.push('justifyLeft');
    }
    if (fl_editor.isCommandEnabled('justifyRight')) {
        items.push('justifyRight');
    }
    if (fl_editor.isCommandEnabled('insertHorizontalRule')) {
        items.push('horizontalRule');
    }
    var formatBlock = document.queryCommandValue('formatBlock');
    if (formatBlock.length > 0) {
        items.push(formatBlock);
    }
    // Images
    $('img').bind('touchstart', function(e) {
                  $('img').removeClass('fl_active');
                  $(this).addClass('fl_active');
                  });
    
    // Use jQuery to figure out those that are not supported
    if (typeof(e) != "undefined") {
        
        // The target element
        var s = fl_editor.getSelectedNode();
        var t = $(s);
        var nodeName = e.target.nodeName.toLowerCase();
        
        // Background Color
        var bgColor = t.css('backgroundColor');
        if (bgColor.length != 0 && bgColor != 'rgba(0, 0, 0, 0)' && bgColor != 'rgb(0, 0, 0)' && bgColor != 'transparent') {
            items.push('backgroundColor');
        }
        // Text Color
        var textColor = t.css('color');
        if (textColor.length != 0 && textColor != 'rgba(0, 0, 0, 0)' && textColor != 'rgb(0, 0, 0)' && textColor != 'transparent') {
            items.push('textColor');
        }
		
		//Fonts
		var font = t.css('font-family');
		if (font.length != 0 && font != 'Arial, Helvetica, sans-serif') {
			items.push('fonts');	
		}
		
        // Link
        if (nodeName == 'a') {
            fl_editor.currentEditingLink = t;
            var title = t.attr('title');
            items.push('link:'+t.attr('href'));
            if (t.attr('title') !== undefined) {
                items.push('link-title:'+t.attr('title'));
            }
            
        } else {
            fl_editor.currentEditingLink = null;
        }
        // Blockquote
        if (nodeName == 'blockquote') {
            items.push('indent');
        }
        // Image
        if (nodeName == 'img') {
            fl_editor.currentEditingImage = t;
            items.push('image:'+t.attr('src'));
            if (t.attr('alt') !== undefined) {
                items.push('image-alt:'+t.attr('alt'));
            }
            
        } else {
            fl_editor.currentEditingImage = null;
        }
        
    }
    
    if (items.length > 0) {
        if (fl_editor.isUsingiOS) {
            //window.location = "fl-callback/"+items.join(',');
            window.location = "callback://0/"+items.join(',');
        } else {
            console.log("callback://"+items.join(','));
        }
    } else {
        if (fl_editor.isUsingiOS) {
            window.location = "fl-callback/";
        } else {
            console.log("callback://");
        }
    }
    
}

fl_editor.focusEditor = function() {
    
    // the following was taken from http://stackoverflow.com/questions/1125292/how-to-move-cursor-to-end-of-contenteditable-entity/3866442#3866442
    // and ensures we move the cursor to the end of the editor
    var editor = $('#fl_editor_content');
    var range = document.createRange();
    range.selectNodeContents(editor.get(0));
    range.collapse(false);
    var selection = window.getSelection();
    selection.removeAllRanges();
    selection.addRange(range);
    editor.focus();
}

fl_editor.blurEditor = function() {
    $('#fl_editor_content').blur();
}

fl_editor.setCustomCSS = function(customCSS) {
    
    document.getElementsByTagName('style')[0].innerHTML=customCSS;
    
    //set focus
    /*editor.focusout(function(){
                    var element = $(this);
                    if (!element.text().trim().length) {
                    element.empty();
                    }
                    });*/
    
    
    
}

//end
