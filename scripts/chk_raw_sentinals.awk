BEGIN{
  incode = 0 ;
}
/```/{
  if(incode==0){
    altered = gensub("```", "{% raw %}```", 1)
    print altered ;
    incode = 1 ;
  } else {
    print $0"{% endraw %}" ;
    incode = 0 ;
  }
  next ;
}
/^##/{
  if(incode==1){
    print "Reached new section2, or lower, with unclosed block"
    incode = 0 ;
  }
}
/^[123456789]\./{
  if(incode==1){
    print "Reached new item with unclosed block"
    incode = 0 ;
  }
}
{
  print $0 ;
}
