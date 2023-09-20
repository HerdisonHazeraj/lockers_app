PACKAGES := $(wildcard packages/*)
FEATURES := $(wildcard packages/features/*)
		
print:
	for package in $(PACKAGES); do \
		echo $${package} ; \
	done
	for feature in $(FEATURES); do \
		echo $${feature} ; \
	done
			
get:
	flutter pub get
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Updating dependencies on $${package}" ; \
		flutter pub get ; \
		cd ../../ ; \
	done
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Updating dependencies on $${feature}" ; \
		flutter pub get ; \
		cd ../../../ ; \
	done
			
lint:
	flutter analyze
			
clean:
	flutter clean
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Running clean on $${package}" ; \
		flutter clean ; \
		cd ../../ ;\
	done
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Running clean on $${feature}" ; \
		flutter clean ; \
		cd ../../../ ;\
	done