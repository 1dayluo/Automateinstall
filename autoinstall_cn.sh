 #!bin/bash
 : '
@name   Automateinstall
@author 1dayluo
@link   https://github.com/1dayluo/Automateinstall
'
: 'Set main variables'
YELLOW="\033[1;33m"
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

COLOR_END="\e[0m"

: 'read md'
processFile(){

    # mdpath='test/recon_tools.md' # for test
    # mdpath='test/test.md'

    if [  -r $mdpath ];then
        h2_index=0
        h3_index=0
        c_index=0
        while read line 
        do
            catg=`echo $line|grep '^## '|awk '{$1="";printf "%s\n",$0}'`
            tool_dict=`echo $line|grep '^###\s'|awk '{$1="";printf "%s\n",$0}'`
            content=`echo $line|grep -v "#"|grep github`
            # echo $tool_dict
            if [[ "$catg" !=  "" ]]
            then
                : 'process heading level 2'
                heading2[$h2_index]=$catg
                : 'save heading level3 and its content'
                h2_index=$((h2_index+1))
                text=""
                tooldir_name=""

            elif [[ "$tool_dict" !=  "" ]];then
                : 'process heading level 3'
                tooldir_name="$tooldir_name
                $tool_dict"

            elif [[ $content != "" ]];then
                : 'process content in heading level 3'
                type=`echo "$tooldir_name"|tail -n 1`
                text="$text
                $type $content"

                
            fi
            if [[ $h2_index -gt 0 ]];then
                h3_content[$h2_index-1]=$text
                heading3[$h2_index-1]=$tooldir_name
            fi
        done < $mdpath

    fi
}

makeRootDir(){
    root=`echo $mdpath|awk -F/ '{print $2}'|awk -F. '{print $1}'`
    read -p "Output path(default:./$root): " rootpath
    if [ -n $rootpath ];then
        rootpath="$root"
    fi
    mkdir -p "./$rootpath" 
}


echo -e "$YELLOW
        ___  _    ____ ____ _    ___  ____ ____ ____ __   ___  ____ ___  __   __   
        |  \ || \ |_ _\|   ||\/\ |  \ |_ _\| __\|___\| \|\| _\ |_ _\|  \ | |  | |  
        | . \||_|\  || | . ||   \| . \  || |  ]_| /  |  \|[__ \  || | . \| |__| |__
        |/\_/|___/  |/ |___/|/v\/|/\_/  |/ |___/|/   |/\_/|___/  |/ |/\_/|___/|___/
        $COLOR_END
"
echo -e  "
welcome use automateinstall tool!
This tool can automatically download the tools in your notes(format is $RED.md$COLOR_END) according to the rules
Please report all bugs and suggestions to https://github.com/1dayluo/Automateinstall

"

echo "Load your .md file"
read -p "Enter path:" mdpath
processFile
makeRootDir

for i in "${!heading2[@]}";
do
    echo -e "[$RED*$COLOR_END](H3)${heading2[$i]} will make dir...."
    mkdir -p  "./$rootpath/${heading2[$i]}"
    tnum=`echo "${heading3[$i]}"|wc -l`
    for ((j=2;j<$((tnum+1));j++))
    do
        topic=`echo  "${heading3[$i]}"|sed -n "${j}"p`
        topic=`eval echo "$topic"
        `
        tools=`echo "${h3_content[$i]}"|grep -v "gist"|grep "$topic"`
        tools_num=`echo "$tools"|wc -l`
        # echo $tools_num
        mkdir -p  "./$rootpath/${heading2[$i]}/$topic"
        echo -e "   $RED+$COLOR_END$YELLOW"$topic"$COLOR_END
        "
        if [[ $tools != "" ]];then
            for ((m=1;m<$((tools_num+1));m++))
            do

                tool=`echo "$tools"|sed -n "${m}"p`
                link=`echo $tool|grep -oh -E "https://[a-zA-Z0-9\.\/_&=@\$%?~#~]*"|sed -n 1p`
                cn_link="https://github.com.cnpmjs.org/"`echo $link|awk -F'com' '{print $2}'`
                echo -e "   [$GREEN url($m) $COLOR_END]:$cn_link
                "
                git clone $cn_link "./$rootpath/${heading2[$i]}/$topic"

            done

        fi

    done
done