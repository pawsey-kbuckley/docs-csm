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
{
  print $0 ;
}
