CPATH='.:../lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

# Source directory
source_dir="student-submission"

# Destination directory
destination_dir="grading-area"

# File to check
file_to_check="ListExamples.java"

#checking if file exists

#if [[ -f "student-submission/ListExamples.java" ]]
#if find /student-submission -type f -name "ListExamples.java"
#then
    #cp "student-submission/ListExamples.java" "grading-area"
if [ -f "$(find "$source_dir" -type f -name "$file_to_check" -print -quit)" ] 
then
    echo "File $file_to_check exists in $source_dir or its subdirectories."
    
    # Copy the file to the destination directory
    cp -nR "$source_dir/$file_to_check" "$destination_dir/"
    cp "TestListExamples.java" "grading-area"
else
    echo "file not found"
    exit 1
fi

cd grading-area

javac -cp $CPATH *.java

if [[ $? -ne 0 ]]
then
    echo "The program failed to compile, see compile error above"
    echo "Your score is 0%"
    exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit.output.txt

lastline=$(cat junit.output.txt | tail -n 2 | head -n 1)

checker=$(echo "$lastline" | cut -c1-2)
if [[ $checker == "OK" ]]
then
    echo "Your score is 100%"
    exit 0
else
    tests=$(echo "$lastline" | cut -c12-12)
    failures=$(echo "$lastline" | cut -c26-26)
    successes=$(($tests - $failures))
    echo "Your score is $successes/$tests"
    exit 1
fi

# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
