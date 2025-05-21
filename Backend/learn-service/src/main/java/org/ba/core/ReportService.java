package org.ba.core;

import java.util.List;

import org.ba.repositories.ReportRepository;
import org.ba.entities.db.ReportEntity;
import org.ba.entities.dto.ReportDTO;
import org.ba.exceptions.ReportPersistException;
import org.ba.core.mapper.ReportMapper;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;

@ApplicationScoped
public class ReportService {
    @Inject
    ReportRepository reportRepository;
    @Inject
    ReportMapper reportMapper;

    @Transactional
    public void saveReport(ReportDTO report) {
        ReportEntity reportEntity = reportMapper.toEntity(report);
        try {
            reportRepository.persist(reportEntity);
        } catch (Exception e) {
            throw new ReportPersistException("Failed to persist report: " + e.getMessage());
        }
        reportMapper.updateDomainFromEntity(reportEntity, report);
    }

    public ReportDTO getReportById(Long reportId) {
        return reportMapper.toDomain(reportRepository.findById(reportId));
    }

    public List<ReportDTO> findAllReportsByLearnerAndEvent(Long learnerId, Long eventId, String sortField, String sortOrder, int timespanInDays) {
        List<ReportEntity> reportEntities = reportRepository.findAllByLearnerAndEvent(learnerId, eventId, sortField, sortOrder, timespanInDays);
        return reportMapper.toDomainList(reportEntities);
    }

    @Transactional
    public void updateReport(Long reportId, ReportDTO report) {
        if (report.getReportId() != null && !report.getReportId().equals(reportId)) {
            report.setReportId(reportId);
            throw new ReportPersistException("Report ID mismatch");
        }
        ReportEntity reportEntity = reportRepository.findById(reportId);
        if (reportEntity == null) {
            throw new ReportPersistException("Report not found");
        }
        if (report.getQuality() != null) {
            reportEntity.setReportQuality(report.getQuality());
        }
        if (report.getReportData() != null) {
            reportEntity.setReportData(report.getReportData());
        }
        reportMapper.updateDomainFromEntity(reportEntity, report);
    }
}
