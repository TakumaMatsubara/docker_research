build:
	docker build -t takuma29/relex_kg:latest .
build_ssrpu:
	docker build -t takuma29/ssrpu:latest -f Dockerfile_SSRPU .
start:
	docker run -it --gpus all --name matsu_relex -v ~/research/ChemDisGene:/workspace -v /data/matsubara.19082/research:/mnt  takuma29/relex_kg:latest
attach:
	docker exec -it matsu_relex zsh
start_preprocess:
	docker run -it --gpus all --name matsubara_preprocess -v ~/research/preprocess_CTD:/workspace takuma29/relex_kg:latest
attach_preprocess:
	docker exec -it matsubara_preprocess zsh
start_analytics:
	docker run -it --gpus all --name matsubara_analytics -v ~/research/ChemDisGene_analytics:/workspace takuma29/relex_kg:latest
attach_analytics:
	docker exec -it matsubara_analytics zsh
start_ssrpu:
	docker run -it --gpus all --name matsubara_ssrpu -v ~/research/ssr-pu:/workspace -v /data/matsubara.19082/research:/mnt  takuma29/ssrpu:latest
attach_ssrpu:
	docker exec -it matsubara_ssrpu__ zsh
