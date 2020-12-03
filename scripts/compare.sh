#!/bin/sh

# -e: fail on first error.
# -u: fail on unset variable.
set -eu

usage="$(basename $0) [-h -d] <fuse src> <benchmark name> <result dir> <futil passes to disable>
Generates synthesis results from <fuse src> using both 'vivado_hls'
and 'vivado' and stores the results in <result dir>"

debug=0
while getopts 'hd' option; do
    case "$option" in
        h) echo "$usage"
           exit
           ;;
        d) debug=1
           shift $((OPTIND -1))
           ;;
        \?) printf "illegal option: -%s\n" "$OPTARG" >&2
            echo "$usage" >&2
            exit 1
            ;;
    esac
done

fuse_file="$1"
benchmark_name="$2"
result_dir="$3"
futil_passes="$4"
script_dir=$(dirname "$0")

# get Futil project directory
if [ -z "$FUTIL_DIR" ]; then
    echo "Environment variable FUTIL_DIR is not set."
    exit 1
fi

# temporary directory
workdir=$(mktemp -d)
echo "Working in $workdir"

# register cleanup function
cleanup() {
    # save the synth results if in debug mode
    if [ $debug -eq 1 ]; then
        mkdir -p _debug
        if [ -d "$workdir/futil" ]; then
            cp -r "$workdir/futil" "_debug/$benchmark_name/"
        fi
        if [ -d "$workdir/hls" ]; then
            cp -r "$workdir/hls" "_debug/$benchmark_name/"
        fi
    else
        echo "Cleaning up $workdir"
        rm -rf "$workdir"
    fi
}
trap cleanup EXIT


#### Generate the files #####
# generate vivado_hls file
dahlia $fuse_file --memory-interface ap_memory > $workdir/"$benchmark_name.cpp"

# generate system verilog file
dahlia $fuse_file -b futil --lower -l error \
    | futil -p external $futil_passes -b verilog -l "$FUTIL_DIR" --synthesis \
          > "$workdir/$benchmark_name.sv"

#### synthesis ####
# run futil and then hls synthesis
$script_dir/vivado.sh 'futil' "$workdir/$benchmark_name.sv" "$workdir/futil"
$script_dir/vivado.sh 'hls' "$workdir/$benchmark_name.cpp" "$workdir/hls"

#### Process Results ####
# copy back the files we need
$script_dir/futil_copy.sh "$workdir/futil" "$result_dir"
$script_dir/hls_copy.sh "$workdir/hls" "$result_dir"

$script_dir/extract.py "$result_dir" > "$result_dir/data.json"
