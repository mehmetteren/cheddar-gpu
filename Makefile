# Please check the file bellow for configuration
#
include Makefile.vars 




# Targets that are part of the binary distribution
#

DISTRIBUTED_BINARIES = cheddar unittest aadl2xml xml2aadl xml2xml aadl2aadl read_write parse_xml_schedule response_time build_schedule_from_xml scc produce_arinc_pst 

INSIDE_DISTRIBUTION : $(DISTRIBUTED_BINARIES)



# Targets managed by ellidiss
#
ELLIDISS_BINARIES = kernel lite

ELLIDISS_DISTRIBUTION : $(ELLIDISS_BINARIES)


# Targets that are NOT part of Cheddar binary distribution
#
OUTSIDE_BINARIES = schedule_monano generate_monano generate_amc schedule_amc schedule_energy generate_energy cnn deadline2energy_exhaustive energy_paes vs F2TArchitectureExplorationExhaustiveMethod prolog F2TArchitectureExplorationPaesMethod F2TInitialSolutionPreprocessing architectureGeneration feasibilityInterval bufferSched feasibilityProcessorUtilization scheduling_anomalies frameworkExamples spacewire_generation cacheAnalysis hierarchical spacewire_transformation.gpr callCheddar T2P_exhaustive_mils callCheddar_securityAnalysis T2P_paes_mils Kways_partitioning T2P_T2C_paes_mils mcs mils optimizations v2eventtabletov3eventtable cPaes paes designPattern design_pattern_repository priorityAssignment dfg noc ppcparchitecturegeneration
OUTSIDE_DISTRIBUTION : $(OUTSIDE_BINARIES)


# Targets for software production tools
#
TOOLS_BINARIES = cut merge xmllint
TOOLS_DISTRIBUTION : $(TOOLS_BINARIES)


all: TOOLS_DISTRIBITION OUTSIDE_DISTRIBUTION ELLIDISS_DISTRIBUTION INSIDE_DISTRIBUTION


# To generate code from Platypus and Flex/Yacc
code_generation:
	(cd framework/scheduling_simulator; make)
	(cd platypus; make)


% : gpr/%.gpr
	gnatmake -P $<  -XBuild=$(RELEASE_OR_DEBUG)

build:
	rm -f $(TARGET)
	echo Building $(TARGET)
	gnatmake  -Pgpr/$(TARGET).gpr  -XBuild=$(RELEASE_OR_DEBUG)

	
clean:
	rm -f gdb.output
	rm -f $(TOOLS_BINARIES) $(OUTSIDE_BINARIES) $(ELLIDISS_BINARIES) $(DISTRIBUTED_BINARIES)
	rm -rf binaries/objects/debug/*
	rm -rf binaries/objects/release/*
	for i in gpr ; do\
		gnatclean -r -P$$i -XBuild=$(RELEASE_OR_DEBUG);\
	done

gdb: 
	gdb dram  --command=scripts/gdb.command

distwindows:
	rm -rf $(VERSION)-Windows-bin
	mkdir $(VERSION)-Windows-bin
	mkdir $(VERSION)-Windows-bin/project_examples
	mkdir $(VERSION)-Windows-bin/glade_files
	cp -pr graphical_editor/glade_files/* $(VERSION)-Windows-bin/glade_files
	cp -pr ../project_examples/xml  $(VERSION)-Windows-bin/project_examples
	cp -pr ../project_examples/aadl  $(VERSION)-Windows-bin/project_examples
	cp -pr ../LICENSE.txt docs/BUGS_TO_FIX.pdf docs/ChangesLog.pdf ../README.md docs/REQUESTED_FEATURES.pdf docs/FIXED_BUGS.pdf docs/TODO.pdf $(VERSION)-Windows-bin
	strip *.exe
	cp -pr ../lib/windows/bin/*.dll $(VERSION)-Windows-bin
	cp -pr ../lib/windows/etc $(VERSION)-Windows-bin
	cp -pr ../lib/windows/lib $(VERSION)-Windows-bin
	cp -pr ../lib/windows/share $(VERSION)-Windows-bin
	cp *.exe $(VERSION)-Windows-bin
	find $(VERSION)-Windows-bin  -name .svn -exec rm -rf  '{}' +
	zip -r $(VERSION)-Windows-bin.zip $(VERSION)-Windows-bin


distlinux: 
	rm -rf $(VERSION)-Linux-bin
	mkdir $(VERSION)-Linux-bin
	mkdir $(VERSION)-Linux-bin/project_examples
	mkdir $(VERSION)-Linux-bin/lib
	mkdir $(VERSION)-Linux-bin/glade_files
	strip $(DISTRIBUTED_BINARIES)
	cp $(DISTRIBUTED_BINARIES)  $(VERSION)-Linux-bin
	cp -pr ../LICENSE.txt docs/BUGS_TO_FIX.pdf docs/ChangesLog.pdf ../README.md docs/REQUESTED_FEATURES.pdf docs/FIXED_BUGS.pdf docs/TODO.pdf $(VERSION)-Linux-bin
	cp -pr ../lib/linux/.  $(VERSION)-Linux-bin/lib
	cp -pr graphical_editor/glade_files/* $(VERSION)-Linux-bin/glade_files
	cp -pr scripts/cheddarlinux.bash.for_installation  $(VERSION)-Linux-bin/cheddar.bash
	cp -pr ../project_examples/xml  $(VERSION)-Linux-bin/project_examples
	cp -pr ../project_examples/aadl  $(VERSION)-Linux-bin/project_examples
	find $(VERSION)-Linux-bin  -name .svn -exec rm -rf  {} +
	tar --exclude='.svn' -cvzf Cheddar-3.3-Linux-bin.tar.gz Cheddar-3.3-Linux-bin


srcdist:
	rm -rf ../releases/$(VERSION)-src
	mkdir ../releases/$(VERSION)-src
	cp -ar * ../releases/$(VERSION)-src
	find ../releases/$(VERSION)-src   -name .svn -exec rm -rf  {} +
	tar --exclude='.svn' -cvzf ../releases/$(VERSION)-src.tar.gz ../releases/$(VERSION)-src 


#
# This target call the GNAT pretty printer
# By default, it pretty prints all files related to cheddar.gpr
# To pretty print any other gpr file, overidde PP_TARGET variable as follow:
#
#make pp PP_TARGET="vs"
#  to pretty print Ada file related to vs.gpr
#
PP_TARGET=T2P_and_security_paes
pp: 
	gnat pretty -v -rnb -aL -kL -neL -ntL -nnL -pL -U -Pgpr/$(PP_TARGET).gpr
	

