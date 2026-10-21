#!/usr/bin/env python

import sys

import numpy
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt

def main():
    rapa_data = numpy.loadtxt('WT_NF_Rapa_counts.tsv')
    nf_data = numpy.loadtxt('WT_NF_Ctrl_counts.tsv')
    nf_rep_data = numpy.loadtxt('WT_NF_Ctrl_rep_counts.tsv')

    # The row and column names are stored in separate files. The sampling time and replicate can be extracted from the sample names
    genes = numpy.array([name.rstrip() for name in open('gene_names.txt')])
    sample_labels = numpy.array([name.rstrip().split('\t') for name in open('samples.txt')])
    times = numpy.array([int(time.split('_')[1]) for time, rep in sample_labels if rep == 1], numpy.int32)
    rep_times = numpy.array([int(time.split('_')[1]) for time, rep in sample_labels], numpy.int32)
    reps = numpy.array([int(rep.split('_')[1]) for time, rep in sample_labels], numpy.int32)

    # do PCA analysis and plot
    pca_analysis_plot(nf_rep_data, rep_times, reps, "replicate_data_pca.png")

    # Step2.1: filtering the data by mean expression and scaled standard deviation
    gene_filter = filter_genes(nf_data)
    filtered_nf_rep_data = nf_rep_data[gene_filter, :]
    filtered_nf_data = nf_data[gene_filter, :]
    filtered_rapa_data = rapa_data[gene_filter, :]

    print("Replicate data:", nf_rep_data.shape, "->", filtered_nf_rep_data.shape)
    print("Ctrl data:", nf_data.shape, "->", filtered_nf_data.shape)
    print("Rapa data:", rapa_data.shape, "->", filtered_rapa_data.shape)

    pca_analysis_plot(filtered_nf_rep_data, rep_times, reps, "filtered_replicate_pca.png")

    # Step2.3: normaliza the data and plot gene PCA
    norm_nf_data = normalize_data(filtered_nf_data)
    norm_rapa_data = normalize_data(filtered_rapa_data)

    #for each ctrl gene, find which of the six timepoints has the highest expression
    peak = numpy.argmax(norm_nf_data, axis=1)

    # Plot the ctrl genes; color each point by its peak timepoint
    x_coords, y_coords = plot_gene_pca(norm_nf_data, peak, "gene_pca.png")

    # Step 3.1 order expression times and plot the data
    angles = numpy.arctan2(y_coords, x_coords)
    plot_hm(norm_nf_data, orderby=angles, xlabel="Timepoint", ylabel='Genes', title="Ctrl genes ordered by PCA angle", fname="ordered_gene_expression_heatmap.png")

    #step3.2: phase expression times and plot data
    aligned_nf_data = align_times(norm_nf_data, angles)
    aligned_rapa_data = align_times(norm_rapa_data, angles)
    plot_hm(aligned_nf_data, xlabel="Aligned timepoint", ylabel='Genes', title = 'Phased Ctrl gene expression', fname='phased_gene_expr_heatmap.png')

    #step3.3: cluster data
    combined_data = numpy.concatenate((aligned_nf_data, aligned_rapa_data), axis =1)
    kmeans = KMeans(n_clusters=6, random_state=42)
    groups = kmeans.fit_predict(combined_data)

    #step3.4 plot clustered data
    plot_hm(aligned_nf_data, aligned_rapa_data, orderby=groups, showgroups=True, xlabel='Aligned timepoint', ylabel='Genes', title='Ctrl and Rapa gene clusters', fname = "clustered_gene_expr_heatmap.png")

def plot_gene_pca (data, colors, fig_name): #Step2.2
    pca = PCA(n_components=2, random_state=42)
    coords = pca.fit_transform(data)

    plt.figure()
    plt.scatter(coords[:,0], coords[:,1],
                c=colors, cmap='Set1', s=5)
    plt.xlabel('PC1')
    plt.ylabel('PC2')
    plt.savefig(fig_name)
    plt.close()

    return coords[:,0], coords[:,1]

def filter_genes(data): # step2.1
    means = numpy.mean(data, axis=1)
    stds = numpy.std(data, axis=1)
    scaled_stds = numpy.divide(stds, means, out=numpy.zeros_like(stds), where=means>0)
    gene_filter = (means > 0.85) & (scaled_stds > 0.115)
    return gene_filter

def pca_analysis_plot(data, times, reps, fig_name): #step1.2
    pca = PCA(random_state=42)
    coords = pca.fit_transform(data.T)

    # Plot
    plt.figure()
    plt.scatter(coords[:, 0], coords[:, 1],
                c = times, cmap='Set1',
                s = reps * 15)
    plt.xlabel('PC1')
    plt.ylabel('PC2')
    plt.savefig(fig_name)
    plt.close()

    


def normalize_data(data):
    """
    Function to normalize data along the second axis of a 2D array.

    Parameters:
    -----------
    data : ndarray
           A 2D matrix containing sample data where the rows are samples and columns are features.

    Returns:
    --------
    norm_data : ndarray
                An array of the sample shape and data type as the original data with values normalized along the second axis.
    """
    norm_data = numpy.copy(data)
    norm_data -= numpy.mean(norm_data, axis=1, keepdims=True)
    norm_data /= numpy.std(norm_data, axis=1, keepdims=True)
    return norm_data


def plot_hm(*data, xlabel='', ylabel='', title='', orderby=None, showgroups=False, fname=None):
    """
    Function for plotting heatmap/matrix style data.

    Parameters:
    -----------
    data : ndarray(s)
           The array or arrays should be 2D with rows plotted along the y-axis and columns plotted along the x-axis.
           If multiple arrays are passed as positional arguments, they need to have the same number of rows.
    xlabel : str
           An x-axis label for the plotted data
    ylabel : str
           A y-axis label for the plotted data
    title : str
           A title to add above the plot
    orderby : ndarray
           A list of indices or group labels for ordering the data along the x-axis. If None, the data order is not changed
    showgroups : bool
           An indicator whether the group labels passed to `orderby` should be plotted as an additional color bar. Ignored if orderby is None.
    fname : str
           A file name to save the plot to. If None, the plot is only displayed but not saved.
    
    Returns:
    --------
    None
    """
    if orderby is None:
        order = numpy.arange(data[0].shape[0])
    else:
        order = numpy.argsort(orderby)
    if orderby is None or not showgroups:
        fig, ax = plt.subplots(1, len(data), figsize=(3, 15))
        if len(data) > 1:
            for i in range(len(data)):
                ax[i].imshow(data[i][order, :], aspect='auto')
                ax[i].set_xlabel(xlabel)
                if i > 0:
                    ax[i].set_yticks([])
            ax[0].set_ylabel(ylabel)
        else:
            ax.imshow(data[0][order, :], aspect='auto')
            ax.set_xlabel(xlabel)
            ax.set_ylabel(ylabel)
    else:
        groups = orderby[order]
        fig, ax = plt.subplots(1, len(data) + 1, width_ratios=[1] + [3] * len(data), figsize=(4, 15))
        if len(data) > 1:
            for i in range(len(data)):
                ax[i + 1].imshow(data[i][order, :], aspect='auto')
                ax[i + 1].set_xlabel(xlabel)
                ax[i + 1].set_ylabel('')
                ax[i + 1].set_yticks([])
        else:
            ax[-1].imshow(data[0][order, :], aspect='auto')
            ax[-1].set_xlabel(xlabel)
            ax[-1].set_ylabel('')
            ax[-1].set_yticks([])
        ax[-1].yaxis.tick_right()
        ax2 = ax[-1].twinx()
        ax2.set_ylabel(ylabel)
        ax[0].set_ylabel('group')
        ax[0].imshow(groups.reshape(-1, 1), aspect='auto')
        bounds = numpy.r_[0, numpy.where(groups[1:] != groups[:-1])[0] + 1, groups.shape[0]] - 0.5
        ax[0].set_yticks((bounds[:-1] + bounds[1:]) / 2)
        ax[0].set_yticklabels([str(i) for i in range(bounds.shape[0] - 1)])
        ax[0].set_xticks([])
    if title:
        plt.suptitle(title)
    if fname is not None:
        plt.savefig(fname, dpi=300, bbox_inches='tight')
    plt.show()


def align_times(data, angle):
    """
    This function takes a 2D matrix of data and a 1D matrix of angles (radians) and shifts data along the second axis (axis=1)
    to align all rows to have an effective angle of zero.

    Parameters:
    -----------
    data : ndarray
           A 2D matrix of data where each row is a sample and each column is a measurement in a cyclical cycle
    angle : ndarray
           A 1D matrix of data of a length equal to the number of rows in data. Angles should be in radians.
           
    Returns:
    --------
    aligned : ndarray
              A new array with data shifted along the second axis to align each row to have an angle of zero
    """
    n = data.shape[1]
    offsets = n - angle * n / (numpy.pi * 2)
    offsets[numpy.where(offsets < 0)] += n
    aligned = numpy.zeros_like(data)
    for i in range(data.shape[0]):
        aligned[i, :] = (numpy.roll(data[i, :], int(numpy.floor(offsets[i]))) * (numpy.ceil(offsets[i]) - offsets[i]) +
                         numpy.roll(data[i, :], int(numpy.ceil(offsets[i]))) * (offsets[i] - numpy.floor(offsets[i])))
    return aligned


main()
