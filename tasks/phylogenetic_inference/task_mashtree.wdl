version 1.0

task mashtree_fasta {
  input {
    Array[File] assembly_fasta
    String cluster_name
    Int truncLength = 250
    String sort_order = "ABC"
    Int genomesize = 5000000
    Int mindepth = 5
    Int kmerlength = 21
    Int sketchsize = 10000
    Int cpu = 16
    Int memory = 64
  }
  command <<<
    # date and version control
    date | tee DATE
    mashtree -v | tee VERSION
    
    # organize input assemblies
    mv ~{sep=' ' assembly_fasta} .
    #run mashtree
    mashtree \
      ~{'--truncLength ' + truncLength} \
      ~{'--sort-order ' + sort_order} \
      ~{'--genomesize ' + genomesize} \
      ~{'--mindepth ' + mindepth} \
      ~{'--kmerlength ' + kmerlength} \
      ~{'--sketch-size ' + sketchsize} \
      ~{'--numcpus ' + cpu} \
      ~{'--outmatrix ' + cluster_name + '.tsv'} \
      ~{'--outtree ' + cluster_name + '.nwk'} \
      *.fasta*
      
  >>>
  output {
    String date = read_string("DATE")
    String version = read_string("VERSION")
    File mashtree_matrix = "~{cluster_name}.tsv"
    File mashtree_tree = "~{cluster_name}.nwk"
  }
  runtime {
    docker: "quay.io/staphb/mashtree:1.2.0"
    memory: "~{memory} GB"
    cpu: cpu
    disks: "local-disk 100 SSD"
    preemptible: 0
  }
}
